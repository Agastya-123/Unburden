import '../secrets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:groq/groq.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SafetyCheck {
  static final RegExp _baseRiskWords = RegExp(
    r"\b(suicid(?:e|al)|self[\s-]?harm|overdose|kill myself|end my life|take my life|end myself|hurt myself|cut myself|hang myself|jump off|want to die|wanna die|should die|need to die|wish i was dead|wish i were dead|better off dead|no point living|die)\b",
    caseSensitive: false,
  );

  static final RegExp _selfRiskPattern = RegExp(
    r"\b(i|i'm|im|i am|me|myself|my)\b.{0,35}\b(suicid(?:e|al)|kill myself|end my life|take my life|end myself|hurt myself|self[\s-]?harm|cut myself|hang myself|jump off|overdose|want to die|wanna die|should die|need to die|wish i was dead|wish i were dead|better off dead|no point living|die)\b|\b(suicid(?:e|al)|kill myself|end my life|take my life|end myself|hurt myself|self[\s-]?harm|cut myself|hang myself|jump off|overdose|want to die|wanna die|should die|need to die|wish i was dead|wish i were dead|better off dead|no point living|die)\b.{0,35}\b(i|i'm|im|i am|me|myself|my)\b",
    caseSensitive: false,
  );

  static final RegExp _otherPersonRiskPattern = RegExp(
    r"\b(friend|my friend|he|she|they|someone|brother|sister|him|her|them)\b.{0,40}\b(suicid(?:e|al)|kill himself|kill herself|kill themselves|end his life|end her life|end their life|want to die|wanna die|overdose)\b|\b(suicid(?:e|al)|kill himself|kill herself|kill themselves|end his life|end her life|end their life|want to die|wanna die|overdose)\b.{0,40}\b(friend|my friend|he|she|they|someone|brother|sister|him|her|them)\b",
    caseSensitive: false,
  );

  static final RegExp _violenceTowardOthersPattern = RegExp(
    r"\b(i|i'm|im|i am|we)\b.{0,25}\b(kill|hurt|harm|stab|shoot)\b.{0,25}\b(him|her|them|someone|my friend|friend)\b",
    caseSensitive: false,
  );

  static const String _scopeSelf = "self";
  static const String _scopeOther = "other";
  static const String _scopeUnknown = "unknown";

  static final RegExp _negationWindowPattern = RegExp(
    r"\b(not|no|never|dont|don't|do not|isnt|isn't|aint|ain't|without)\b",
    caseSensitive: false,
  );

  static bool _hasNearbyNegation(String text, int matchStart, int matchEnd) {
    final int windowStart = (matchStart - 20).clamp(0, text.length);
    final int windowEnd = (matchEnd + 10).clamp(0, text.length);
    final String window = text.substring(windowStart, windowEnd);
    return _negationWindowPattern.hasMatch(window);
  }

  static Map<String, dynamic> checkTriggeringWords(String text) {
    final String normalizedText = text
        .toLowerCase()
        .replaceAll(String.fromCharCode(0x2019), "'")
        .replaceAll('`', "'")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();
    final List<String> matches = [];
    final List<String> negatedMatches = [];

    for (final Match match in _baseRiskWords.allMatches(normalizedText)) {
      final String? token = match.group(0);
      if (token == null || token.isEmpty) {
        continue;
      }
      if (_hasNearbyNegation(normalizedText, match.start, match.end)) {
        if (!negatedMatches.contains(token)) {
          negatedMatches.add(token);
        }
        continue;
      }
      if (!matches.contains(token)) {
        matches.add(token);
      }
    }

    final bool hasBaseRiskWords = matches.isNotEmpty;
    final bool isSelfRisk = hasBaseRiskWords &&
        (_selfRiskPattern.hasMatch(normalizedText) || normalizedText.trim() == "die");
    final bool isOtherPersonRisk = _otherPersonRiskPattern.hasMatch(normalizedText);
    final bool isViolenceTowardOthers = _violenceTowardOthersPattern.hasMatch(normalizedText);

    String scope = _scopeUnknown;
    if (isSelfRisk) {
      scope = _scopeSelf;
    } else if (isOtherPersonRisk || isViolenceTowardOthers) {
      scope = _scopeOther;
    }

    if (hasBaseRiskWords || isViolenceTowardOthers) {
      print("⚠️ SAFETY CHECK: Trigger content detected | scope=$scope | matches=$matches | negated=$negatedMatches");
      return {
        "detected": true,
        "scope": scope,
        "matches": matches,
        "negatedMatches": negatedMatches,
      };
    }

    print("✅ SAFETY CHECK: No trigger content found");
    return {
      "detected": false,
      "scope": _scopeUnknown,
      "matches": <String>[],
      "negatedMatches": negatedMatches,
    };
  }

  static Future<Map<String, dynamic>> checkHarmfulTone(String text) async {
    try {
      final groqConfiguration = Configuration(
        model: "llama-3.1-8b-instant",
        temperature: 0.3,
      );

      final safetyGroq = Groq(
        apiKey: Secrets.groqApiKey,
        configuration: groqConfiguration,
      );

      safetyGroq.startChat();
      
      final GroqResponse response = await safetyGroq.sendMessage(
        "Analyze this message for immediate safety risk. "
        "Classify into EXACTLY one of these labels: "
        "SELF_CRITICAL, OTHER_PERSON_AT_RISK, VIOLENCE_TOWARD_OTHERS, SAFE. "
        "Use SELF_CRITICAL only when speaker directly indicates self-harm or suicide intent. "
        "Use OTHER_PERSON_AT_RISK when speaker reports someone else may self-harm/suicide. "
        "Use VIOLENCE_TOWARD_OTHERS when speaker indicates intent to harm/kill others. "
        "Do NOT flag general sadness, stress, negative emotions, jokes, or vague statements. "
        "Be very strict to reduce false positives. "
        "Message: $text\n\n"
        "Respond with ONLY one label from this set: "
        "SELF_CRITICAL, OTHER_PERSON_AT_RISK, VIOLENCE_TOWARD_OTHERS, SAFE."
      );

      String responseText = response.choices.first.message.content.trim().toUpperCase();
      String category = "SAFE";
      if (responseText.contains('SELF_CRITICAL')) {
        category = "SELF_CRITICAL";
      } else if (responseText.contains('OTHER_PERSON_AT_RISK')) {
        category = "OTHER_PERSON_AT_RISK";
      } else if (responseText.contains('VIOLENCE_TOWARD_OTHERS')) {
        category = "VIOLENCE_TOWARD_OTHERS";
      }

      bool isCritical = category != "SAFE";
      if (isCritical) {
        print("⚠️ SAFETY CHECK: AI detected risk category=$category");
      } else {
        print("✅ SAFETY CHECK: AI tone check - SAFE");
      }
      return {
        "isCritical": isCritical,
        "category": category,
      };
    } catch (e) {
      print("❌ SAFETY CHECK: Error checking tone: $e");
      return {
        "isCritical": false,
        "category": "SAFE",
      };
    }
  }

  static Future<String?> getGuardianEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('guardian_email_id')) {
          String email = userData['guardian_email_id'].toString().trim();
          if (email.isNotEmpty && email.contains('@')) {
            return email;
          }
        }
      }
      return null;
    } catch (e) {
      print("Error getting guardian email: $e");
      return null;
    }
  }

  static Future<bool> sendGuardianAlert({
    required String emailAddress,
    required String context,
    required String userMessage,
    List<Map<String, String>>? conversationHistory,
    String riskScope = _scopeUnknown,
    String aiCategory = "SAFE",
    List<String>? matchedWords,
    List<String>? reasons,
  }) async {
    try {
      const String smtpHost = 'smtp.gmail.com';
      const int smtpPort = 587;
      const String smtpUsername = Secrets.smtpUsername;
      const String smtpPassword = Secrets.smtpPassword;
      const String fromEmail = 'unburden.antibullying@gmail.com';
      const String fromName = 'Unburden App';
      
      final smtpServer = SmtpServer(
        smtpHost,
        port: smtpPort,
        username: smtpUsername,
        password: smtpPassword,
      );

      String escapedUserMessage = userMessage
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('"', '&quot;')
          .replaceAll("'", '&#39;');

      final bool hasImmediateSelfRisk =
          riskScope == _scopeSelf || aiCategory == "SELF_CRITICAL";
      final bool hasOtherPersonRisk = riskScope == _scopeOther &&
          aiCategory != "VIOLENCE_TOWARD_OTHERS";
      final bool hasViolenceTowardOthers = aiCategory == "VIOLENCE_TOWARD_OTHERS";
      final bool shouldShareFullMessage = hasImmediateSelfRisk || hasViolenceTowardOthers;

      String situationTitle = "Your child may need emotional support right now";
      String situationSummary =
          "We noticed signs that your child may be going through something difficult and may benefit from calm, immediate support.";
      if (hasImmediateSelfRisk) {
        situationTitle = "Your child may need urgent emotional support";
        situationSummary =
            "We noticed signs that your child may be struggling and could benefit from immediate, calm support.";
      } else if (hasViolenceTowardOthers) {
        situationTitle = "Your child may be feeling intense anger or distress";
        situationSummary =
            "The message suggests strong emotions that may need calm guidance and support to de-escalate safely.";
      } else if (hasOtherPersonRisk || aiCategory == "OTHER_PERSON_AT_RISK") {
        situationTitle = "Your child may be concerned about someone else";
        situationSummary =
            "They may be sharing something important about another person and could need help in responding safely.";
      }

      String situationalHtmlAdvice = '''
                  <div class="guidance-item">
                    <strong>Immediate first step:</strong> Stay calm, thank your child for sharing, and move to a private safe place to talk.
                  </div>
      ''';
      String situationalTextAdvice = '''
✓ Immediate first step
  Stay calm, thank your child for sharing, and move to a private safe place to talk.
''';

      if (hasImmediateSelfRisk) {
        situationalHtmlAdvice = '''
                  <div class="guidance-item">
                    <strong>For urgent emotional distress:</strong> Stay with your child and speak gently. Let them know they are safe and not in trouble.
                  </div>
                  <div class="guidance-item">
                    <strong>Next step:</strong> Gently check in by asking how they are feeling and whether they feel safe right now. Stay close and make the environment safer if needed.
                  </div>
                  <div class="guidance-item">
                    <strong>What to say:</strong> "I’m here with you. You’re not alone. We’ll figure this out together."
                  </div>
        ''';
        situationalTextAdvice = '''
✓ For urgent emotional distress
  Stay with your child and speak gently. Let them know they are safe and not in trouble.

✓ Next step
  Gently check in by asking how they are feeling and whether they feel safe right now.
  Stay close and make the environment safer if needed.

✓ What to say
  "I’m here with you. You’re not alone. We’ll figure this out together."
''';
      } else if (hasViolenceTowardOthers) {
        situationalHtmlAdvice = '''
                  <div class="guidance-item">
                    <strong>For intense anger or conflict risk:</strong> Focus on keeping everyone safe. Stay calm, avoid confrontation, and gently guide your child away from the situation.
                  </div>
                  <div class="guidance-item">
                    <strong>Next step:</strong> Ask what happened and what they are feeling, then involve a mental-health professional or school counselor promptly.
                  </div>
        ''';
        situationalTextAdvice = '''
✓ For intense anger or conflict risk
  Focus on keeping everyone safe. Stay calm, avoid confrontation, and gently guide your child away from the situation.

✓ Next step
  Ask what happened and what they are feeling, then involve a mental-health professional or school counselor promptly.
''';
      } else if (hasOtherPersonRisk || aiCategory == "OTHER_PERSON_AT_RISK") {
        situationalHtmlAdvice = '''
                  <div class="guidance-item">
                    <strong>If someone else may be at risk:</strong> Let your child know they did the right thing by speaking up.
                  </div>
                  <div class="guidance-item">
                    <strong>Next step:</strong> Ask who the person is and whether there is immediate danger, then help your child contact a trusted adult (parent, school counselor, teacher) as soon as possible.
                  </div>
        ''';
        situationalTextAdvice = '''
✓ If someone else may be at risk
  Let your child know they did the right thing by speaking up.

✓ Next step
  Ask who the person is and whether there is immediate danger, then help your child contact a trusted adult (parent, school counselor, teacher) as soon as possible.
''';
      }

      String conversationHistoryHtml = '';
      String conversationHistoryText = '';
      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        conversationHistoryHtml = '''
                <div style="background: #e3f2fd; border-left: 5px solid #2196f3; padding: 20px; margin: 25px 0; border-radius: 5px;">
                  <h3 style="margin-top: 0; color: #1976d2; font-size: 16px;">💬 Conversation History:</h3>
                  <div style="background: white; padding: 15px; border-radius: 5px; max-height: 400px; overflow-y: auto;">
        ''';
        
        for (var msg in conversationHistory) {
          String role = msg['role'] ?? 'Unknown';
          String message = msg['message'] ?? '';
          String escapedMsg = message
              .replaceAll('&', '&amp;')
              .replaceAll('<', '&lt;')
              .replaceAll('>', '&gt;')
              .replaceAll('"', '&quot;')
              .replaceAll("'", '&#39;');
          String bgColor = role == 'User' ? '#fff9c4' : '#f3e5f5';
          String textColor = role == 'User' ? '#f57f17' : '#7b1fa2';
          
          conversationHistoryHtml += '''
                        <div style="margin: 10px 0; padding: 10px; background: $bgColor; border-radius: 5px; border-left: 3px solid $textColor;">
                          <strong style="color: $textColor; font-size: 12px;">$role:</strong>
                          <div style="margin-top: 5px; white-space: pre-wrap; font-size: 13px;">$escapedMsg</div>
                        </div>
          ''';
          
          conversationHistoryText += '$role: $message\n\n';
        }
        
        conversationHistoryHtml += '''
                  </div>
                </div>
        ''';
      }

      final message = Message()
        ..from = Address(fromEmail, fromName)
        ..recipients.add(emailAddress)
        ..subject = '🚨 Important: Support Needed'
        ..html = '''
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <style>
              body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
              .container { max-width: 600px; margin: 0 auto; padding: 20px; }
              .header { background: linear-gradient(135deg, #ff8a65 0%, #ff7043 100%); color: white; padding: 25px; border-radius: 10px 10px 0 0; text-align: center; }
              .header h1 { margin: 0; font-size: 24px; }
              .content { background: #ffffff; padding: 30px; border: 1px solid #e0e0e0; border-top: none; }
              .alert-box { background: #fff3cd; border-left: 5px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 5px; }
              .message-box { background: #f8f9fa; border: 2px solid #ff6b6b; border-radius: 8px; padding: 20px; margin: 20px 0; }
              .message-text { white-space: pre-wrap; font-family: 'Courier New', monospace; font-size: 14px; line-height: 1.8; color: #2c3e50; }
              .guidance-section { background: #e8f5e9; border-left: 5px solid #4caf50; padding: 20px; margin: 25px 0; border-radius: 5px; }
              .guidance-section h3 { color: #2e7d32; margin-top: 0; font-size: 18px; }
              .guidance-item { background: white; padding: 12px 15px; margin: 10px 0; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
              .guidance-item strong { color: #4caf50; }
              .footer { background: #f5f5f5; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; color: #666; font-size: 12px; }
              .context-badge { display: inline-block; background: #2196f3; color: white; padding: 5px 15px; border-radius: 20px; font-size: 12px; font-weight: bold; }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="header">
                <h1>Important Support Alert</h1>
                <p style="margin: 10px 0 0 0; font-size: 16px;">Unburden App</p>
              </div>
              
              <div class="content">
                <div class="alert-box">
                  <strong>Hello,</strong> We are reaching out because your child may need support right now.
                </div>
                
                <div style="margin: 25px 0;">
                  <strong>Context:</strong> <span class="context-badge">$context</span>
                </div>

                <div style="background: #fff8e1; border-left: 5px solid #ff9800; padding: 15px; margin: 20px 0; border-radius: 5px;">
                  <h3 style="margin-top: 0; color: #e65100; font-size: 16px;">Situation Summary</h3>
                  <p style="margin: 6px 0;"><strong>Risk Type:</strong> $situationTitle</p>
                  <p style="margin: 6px 0;">$situationSummary</p>
                </div>

                <div class="alert-box" style="background: #e3f2fd; border-left-color: #2196f3;">
                  <strong>💙 Your presence matters right now.</strong> Staying calm and supportive can make a big difference.
                </div>

                ${shouldShareFullMessage ? '''
                <div class="message-box">
                  <h3 style="margin-top: 0; color: #ff6b6b; font-size: 16px;">📝 Message</h3>
                  <div class="message-text">$escapedUserMessage</div>
                </div>
                ''' : '''
                <div class="message-box">
                  <h3 style="margin-top: 0; color: #ff6b6b; font-size: 16px;">📝 Message Context</h3>
                  <div class="message-text">A message was detected that suggests the child may need support. For privacy, full message text is not included for this alert level.</div>
                </div>
                '''}
                
                ${shouldShareFullMessage ? conversationHistoryHtml : ''}
                
                <div class="guidance-section">
                  <h3>💚 How to Respond - IMPORTANT GUIDANCE:</h3>
                  $situationalHtmlAdvice
                  
                  <div class="guidance-item">
                    <strong>✓ Be Gentle & Supportive:</strong> Approach your child with kindness and understanding. Avoid being confrontational or accusatory.
                  </div>
                  
                  <div class="guidance-item">
                    <strong>✓ Avoid Cross-Questioning:</strong> Don't bombard them with questions or make them feel guilty. This can make them shut down.
                  </div>
                  
                  <div class="guidance-item">
                    <strong>✓ Express Your Love:</strong> Let them know you love them unconditionally and that you're always here to listen without judgment.
                  </div>
                  
                  <div class="guidance-item">
                    <strong>✓ Create a Safe Space:</strong> Make them feel comfortable and safe to open up. Be patient and let them share at their own pace.
                  </div>
                  
                  <div class="guidance-item">
                    <strong>✓ Seek Professional Help:</strong> Consider reaching out to mental health professionals or counselors who specialize in youth support.
                  </div>

                  <div class="guidance-item">
                    <strong>✓ Avoid these common mistakes:</strong> Do not shame, threaten punishment, or dismiss feelings with phrases like "you are overreacting."
                  </div>

                  <div class="guidance-item">
                    <strong>✓ Follow-up plan (next 24 hours):</strong> Check in again, keep supervision proportionate to risk, and schedule a counselor/mental-health conversation quickly.
                  </div>
                </div>
                
                <div style="background: #fff3cd; padding: 20px; border-radius: 8px; margin: 25px 0; text-align: center;">
                  <p style="margin: 0; font-size: 16px; font-weight: bold; color: #856404;">
                    💙 Remember: Your child needs support and understanding right now. Your presence and care can make a significant difference.
                  </p>
                </div>
              </div>
              
              <div class="footer">
                <p>This is an automated alert from the Unburden App</p>
                <p>This alert was sent to help you support them - not to monitor or judge.</p>
                <p>If you believe there is immediate danger, contact local emergency services or a mental health helpline.</p>
              </div>
            </div>
          </body>
          </html>
        '''
        ..text = '''
═══════════════════════════════════════════════════════════
🚨 IMPORTANT: SUPPORT NEEDED
═══════════════════════════════════════════════════════════

Hello,
We're reaching out because your child may need support right now.

Context: $context

Risk Type: $situationTitle
Summary: $situationSummary

💙 Your presence matters right now. Staying calm and supportive
can make a meaningful difference.

───────────────────────────────────────────────────────────
📝 MESSAGE CONTEXT:
───────────────────────────────────────────────────────────
${shouldShareFullMessage ? userMessage : "A message was detected that suggests the child may need support. For privacy, full message text is not included for this alert level."}
───────────────────────────────────────────────────────────

${shouldShareFullMessage && conversationHistoryText.isNotEmpty ? '''
───────────────────────────────────────────────────────────
💬 CONVERSATION HISTORY:
───────────────────────────────────────────────────────────
$conversationHistoryText
───────────────────────────────────────────────────────────
''' : ''}

═══════════════════════════════════════════════════════════
💚 HOW TO RESPOND - IMPORTANT GUIDANCE:
═══════════════════════════════════════════════════════════

$situationalTextAdvice

✓ Be Gentle & Supportive
  Approach your child with kindness and understanding. 
  Avoid being confrontational or accusatory.

✓ Avoid Cross-Questioning
  Don't bombard them with questions or make them feel guilty. 
  This can make them shut down.

✓ Express Your Love
  Let them know you love them unconditionally and that you're 
  always here to listen without judgment.

✓ Create a Safe Space
  Make them feel comfortable and safe to open up. Be patient 
  and let them share at their own pace.

✓ Seek Professional Help
  Consider reaching out to mental health professionals or 
  counselors who specialize in youth support.

✓ Avoid common mistakes
  Don't shame, threaten punishment, or dismiss feelings
  with phrases like "you are overreacting."

✓ Follow-up plan (next 24 hours)
  Check in again, keep supervision proportionate to risk,
  and schedule a counselor/mental-health conversation quickly.

───────────────────────────────────────────────────────────
💙 Remember: Your child needs support and understanding 
right now. Your presence and care can make a significant 
difference.
───────────────────────────────────────────────────────────

This is an automated alert from the Unburden App.
This alert was sent to help you support them - not to monitor
or judge.
If you believe there is immediate danger, contact local
emergency services or a mental health helpline.
        ''';
      
      print("📧 Email Alert Details:");
      print("   To: $emailAddress");
      print("   Subject: Important: Support Needed");
      print("   Context: $context");

      try {
        final sendReport = await send(message, smtpServer);
        print("✅ Email alert sent successfully to $emailAddress");
        print("📧 Send report: $sendReport");
        return true;
      } catch (e) {
        print("❌ Email alert failed to send");
        print("❌ Error: $e");
        return false;
      }
    } catch (e) {
      print("❌ Error sending email alert: $e");
      return false;
    }
  }

  static Future<bool> performSafetyCheck({
    required String text,
    required String context,
    List<Map<String, String>>? conversationHistory,
  }) async {
    print("\n🔍 SAFETY CHECK STARTED - Context: $context");
    print("📝 Message preview: ${text.length > 50 ? text.substring(0, 50) + '...' : text}");
    
    final Map<String, dynamic> detection = checkTriggeringWords(text);
    final bool hasTriggeringWords = detection["detected"] == true;
    final String triggerScope = detection["scope"] as String? ?? _scopeUnknown;
    final List<String> matchedWords =
        (detection["matches"] as List<dynamic>? ?? <dynamic>[])
            .map((e) => e.toString())
            .toList();

    Map<String, dynamic> aiDetection = {
      "isCritical": false,
      "category": "SAFE",
    };
    bool hasHarmfulTone = false;
    String aiCategory = "SAFE";

    if (hasTriggeringWords && triggerScope == _scopeSelf) {
      print("Running AI tone check after direct self-harm keyword match...");
      aiDetection = await checkHarmfulTone(text);
      hasHarmfulTone = aiDetection["isCritical"] == true;
      aiCategory = aiDetection["category"] as String? ?? "SAFE";
    } else {
      print("Skipping AI tone check because the message was not a direct self-harm match");
    }

    final bool isSelfHarmRisk =
        hasTriggeringWords &&
        (triggerScope == _scopeSelf || aiCategory == "SELF_CRITICAL");
    final bool shouldTriggerAlert = isSelfHarmRisk;

    if (shouldTriggerAlert) {
      final List<String> reasons = [];
      if (hasTriggeringWords) {
        reasons.add("manual trigger match");
      }
      if (hasHarmfulTone) {
        reasons.add("AI $aiCategory");
      }

      print("🚨 ALERT TRIGGERED: ${reasons.join(' + ')} | manualScope=$triggerScope | aiCategory=$aiCategory | matches=$matchedWords");

      String? guardianEmail = await getGuardianEmail();
      if (guardianEmail != null) {
        print("📧 Sending email alert to guardian: $guardianEmail");

        const String scopeMessage =
            "User appears to be talking about self-harm/suicidal thoughts";
        final String matchedText = matchedWords.isNotEmpty
            ? " | matched: ${matchedWords.join(', ')}"
            : "";
        final String reasonText = " | reason: ${reasons.join(' + ')}";

        bool sent = await sendGuardianAlert(
          emailAddress: guardianEmail,
          context: context == "chatbot"
              ? "User sent a message in the chatbot ($scopeMessage$matchedText$reasonText)"
              : "User wrote a journal entry ($scopeMessage$matchedText$reasonText)",
          userMessage: text,
          conversationHistory: conversationHistory,
          riskScope: triggerScope,
          aiCategory: aiCategory,
          matchedWords: matchedWords,
          reasons: reasons,
        );
        if (sent) {
          print("✅ Email alert sent successfully");
        } else {
          print("❌ Email alert failed to send");
        }
      } else {
        print("⚠️ No guardian email found - alert not sent");
      }

      print("🔍 SAFETY CHECK COMPLETE - Alert triggered\n");
      return true;
    }

    print("✅ SAFETY CHECK COMPLETE - No self-harm alert needed\n");
    return false;
  }
}

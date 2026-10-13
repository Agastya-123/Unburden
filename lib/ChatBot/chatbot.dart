import '../secrets.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/BottomNav.dart';
import '/Home/Games/coloring/coloring_options.dart';
import '/Home/Games/flipcardgame.dart';
import '/Home/Games/puzzle/puzzle_options.dart';
import '/Home/Meditation/meditation options.dart';
import '/Home/Questionnaire/Questionnaire.dart';
import '/Home/challenge_journey.dart';
import '/Journal/journal.dart';
import '/colors.dart';
import '../utils/safety_check.dart';
import '../utils/safety_support_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groq/groq.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.task, required this.text}) : super(key: key);
  final String task;
  final String text;

  @override
  State createState() => ChatScreenState();
}

enum _PendingClarification {
  hotline,
  source,
}

class ChatScreenState extends State<ChatScreen> {
  static const String _safetyLockUntilMsKey = "chatbot_safety_lock_until_ms";
  static const Duration _safetyLockDuration = Duration(hours: 24);
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  _PendingClarification? _pendingClarification;
  Set<String> _lastSuggestedIds = <String>{};
  int _consecutiveSuggestionRejections = 0;
  final Configuration _introGroqConfig = Configuration(
    model: "llama-3.1-8b-instant",
    temperature: 0.9,
  );

  late final Groq _introGroq = Groq(
    apiKey: Secrets.groqApiKey,
    configuration: _introGroqConfig,
  );
  final Configuration _replyGroqConfig = Configuration(
    model: "llama-3.1-8b-instant",
    temperature: 0.35,
  );

  late final Groq _replyGroq = Groq(
    apiKey: Secrets.groqApiKey,
    configuration: _replyGroqConfig,
  );

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    final bool blocked = await _showSafetyDialogIfLocked();
    if (!mounted || blocked) return;
    _seedWelcomeMessage();
  }

  Future<void> _setSafetyLockNow() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int lockUntilMs =
        DateTime.now().add(_safetyLockDuration).millisecondsSinceEpoch;
    await prefs.setInt(_safetyLockUntilMsKey, lockUntilMs);
  }

  Future<bool> _isSafetyLockActive() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? lockUntilMs = prefs.getInt(_safetyLockUntilMsKey);
    if (lockUntilMs == null) return false;
    return DateTime.now().millisecondsSinceEpoch < lockUntilMs;
  }

  Future<bool> _showSafetyDialogIfLocked() async {
    final bool isLocked = await _isSafetyLockActive();
    if (!isLocked || !mounted) return false;
    await SafetySupportDialog.show(context);
    if (!mounted) return true;
    _closeChatbotScreen();
    return true;
  }

  void _closeChatbotScreen() {
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePageScreen()),
    );
  }

  Future<void> _seedWelcomeMessage() async {
    const String introBase = "Hi, I'm Ray. I'm a red panda. I'm here to help you.";
    final String introTail = await _generateIntroTail();
    if (!mounted) return;
    final String sessionIntro =
        "$introBase $introTail What's been going on that you'd like to talk about?";

    final _SupportReply welcomeReply = widget.task == "journal"
        ? _buildJournalWelcomeReply(widget.text, sessionIntro)
        : const _SupportReply(message: "", suggestionIds: []);

    setState(() {
      _messages.add(_createMessage(
        text: widget.task == "journal" ? welcomeReply.message : sessionIntro,
        isUserMessage: false,
        suggestions: _buildSuggestions(welcomeReply.suggestionIds),
      ));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottomWithDelay(const Duration(milliseconds: 100));
    });
  }

  Future<String> _generateIntroTail() async {
    try {
      _introGroq.startChat();
      final GroqResponse response = await _introGroq.sendMessage(
        "Write one short warm sentence for Ray, a supportive red panda friend.\n"
        "Rules:\n"
        "- One sentence only.\n"
        "- 6 to 14 words.\n"
        "- Keep it simple and kind for teens.\n"
        "- Do not mention hotlines, diagnosis, or medical advice.\n"
        "- Do not repeat: 'I'm Ray', 'red panda', or 'I'm here to help you'.\n"
        "- Return only the sentence.",
      );
      final String line = response.choices.first.message.content.trim();
      if (line.isNotEmpty) return line;
    } catch (_) {
    }
    return "You can share anything here, and we'll take it one step at a time.";
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add(_createMessage(text: text, isUserMessage: true));
    });

    _scrollToBottomWithDelay(const Duration(milliseconds: 200));

    _sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: themecolor,
        leading: IconButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
              return;
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePageScreen()),
            );
          },
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black, size: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (_, int index) {
                  final m = _messages[index];

                  if (m['isError'] == true) {
                    return ErrorMessage(text: m['text'] ?? 'Error');
                  }

                  return ChatMessage(
                    id: m['id'],
                    text: m['text'],
                    isUserMessage: m['isUserMessage'] ?? false,
                    liked: m['liked'] ?? false,
                    disliked: m['disliked'] ?? false,
                    suggestions: ((m['suggestions'] ?? const []) as List)
                        .map((s) => Map<String, String>.from(s as Map))
                        .toList(),
                    onSuggestionTap: _openSuggestedFeature,
                    onFeedback: (like) {
                      setState(() {
                        if (like) {
                          m['liked'] = !(m['liked'] ?? false);
                          m['disliked'] = false;
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Thanks for the feedback!')),
                          // );
                          const snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: '',
                              message:
                              'Thanks for the feedback!',
                              contentType: ContentType.success,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        } else {
                          m['disliked'] = !(m['disliked'] ?? false);
                          m['liked'] = false;
                        }
                      });

                      if (!(m['isUserMessage'] ?? false) && (m['disliked'] == true)) {
                        print("open");
                        _openReportSheet(context, m['id'], m['text']);
                      }
                    },
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Send a message',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _handleSubmitted,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scrollToBottomWithDelay(Duration delay) async {
    await Future.delayed(delay);
    if (!mounted || !_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _sendMessage(String text) async {
    try {
      final bool blocked = await _showSafetyDialogIfLocked();
      if (!mounted || blocked) return;

      List<Map<String, String>> conversationHistory = [];
      for (var msg in _messages) {
        conversationHistory.add({
          'role': (msg['isUserMessage'] == true) ? 'User' : 'Ray',
          'message': msg['text'] ?? '',
        });
      }
      conversationHistory.add({
        'role': 'User',
        'message': text,
      });

      final bool safetyTriggered = await SafetyCheck.performSafetyCheck(
        text: text,
        context: "chatbot",
        conversationHistory: conversationHistory,
      );
      if (!mounted) return;
      if (safetyTriggered) {
        await _setSafetyLockNow();
        _appendBotMessage(
          "I’m really sorry you’re feeling this way. You don’t have to go through this alone.",
        );
        await SafetySupportDialog.show(context);
        if (!mounted) return;
        _closeChatbotScreen();
        return;
      }

      _updateSuggestionFeedbackState(text);
      final _SupportReply fallbackReply = _buildSupportReply(text);
      final _SupportReply aiReply = await _generateReplyAndSuggestionsWithGroq(
        userText: text,
        fallbackReply: fallbackReply,
      );
      if (!mounted) return;
      _appendBotMessage(
        aiReply.message,
        suggestions: _buildSuggestions(aiReply.suggestionIds),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(_createMessage(
          text: "I hit a small bump while opening support options. Please try again.",
          isUserMessage: false,
          isError: true,
        ));
      });
    }

    _scrollToBottomWithDelay(const Duration(milliseconds: 300));
  }

  void _updateSuggestionFeedbackState(String userText) {
    final String normalized = userText
        .toLowerCase()
        .replaceAll(String.fromCharCode(0x2019), "'")
        .replaceAll('`', "'")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();

    final bool rejected = _isSuggestionRejection(normalized);
    if (rejected && _lastSuggestedIds.isNotEmpty) {
      _consecutiveSuggestionRejections += 1;
      return;
    }

    if (!rejected) {
      _consecutiveSuggestionRejections = 0;
    }
  }

  bool _isSuggestionRejection(String normalized) {
    if (RegExp(r"^no+$").hasMatch(normalized)) return true;
    return _containsAny(normalized, [
      "no thanks",
      "dont want",
      "don't want",
      "not helpful",
      "not helping",
      "didn't help",
      "doesn't help",
      "already tried",
      "tried that",
      "something else",
      "another option",
      "another suggestion",
      "stop suggesting",
      "different suggestion",
      "not this",
    ]);
  }

  Future<_SupportReply> _generateReplyAndSuggestionsWithGroq({
    required String userText,
    required _SupportReply fallbackReply,
  }) async {
    const List<String> allowedSuggestionIds = <String>[
      "journal",
      "meditation",
      "puzzle",
      "memory_flip",
      "daily_challenges",
      "coloring",
      "questionnaire",
    ];

    try {
      if (_mustKeepDeterministicReply(fallbackReply)) {
        return fallbackReply;
      }

      _replyGroq.startChat();
      final GroqResponse response = await _replyGroq.sendMessage(
        "You are Ray, a caring support companion for teens.\n"
        "Task: Write a warm, natural response and choose up to 2 support feature cards.\n"
        "Strict rules:\n"
        "- Keep responses short (1 to 3 sentences). Dont ask why are you feeling this ways. Just suggest ways to not feel this way. Dont repeat sugegstions if they say no to them teh first time.\n"
        "- Keep tone compassionate and conversational.\n"
        "- Do NOT write in checklist or to-do list style.\n"
        "- Do NOT diagnose or give any medical advices.\n"
        "- Stay ONLY on emotional support, bullying/feelings support, and safe coping steps.\n"
        "- If user asks generic/non-support topics (math, coding, search, etc), politely refuse and redirect to emotional support.\n"
        "- For hotline/source asks: ask clarification if unclear; give only specific number if clearly requested; if unknown, say you don't know and ask them to contact a friend/trusted adult.\n"
        "- For depressed/anxiety type messages: be thoughtful first; mention friend support and trusted adult/professional support before calming practice.\n"
        "- Suggestions must come ONLY from this allowlist: journal, meditation, puzzle, memory flip, dialy chalalnges, coloring, questionnaire.\n"
        "- Keep suggestions light (0 to 2 max).\n"
        "- Return valid JSON only with this shape:\n"
        "{\"message\":\"...\",\"suggestionIds\":[\"...\"]}\n\n"
        "User message: $userText\n"
        "Fallback reply (use if needed): ${fallbackReply.message}\n"
        "Fallback suggestionIds: ${fallbackReply.suggestionIds.join(", ")}",
      );
      final String raw = response.choices.first.message.content.trim();
      if (raw.isEmpty) return fallbackReply;

      final dynamic decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return fallbackReply;

      final String message = (decoded["message"] ?? "").toString().trim();
      if (message.isEmpty) return fallbackReply;

      final dynamic suggestionListRaw = decoded["suggestionIds"];
      final List<String> suggestionIds = suggestionListRaw is List
          ? suggestionListRaw
              .map((e) => e.toString())
              .where((id) => allowedSuggestionIds.contains(id))
              .toSet()
              .take(2)
              .toList()
          : <String>[];

      final _SupportReply candidate = _SupportReply(
        message: message,
        suggestionIds: suggestionIds,
      );
      if (!_isGroqReplyCompliant(
        fallbackReply: fallbackReply,
        candidate: candidate,
        userText: userText,
      )) {
        return fallbackReply;
      }
      return candidate;
    } catch (_) {
      return fallbackReply;
    }
  }

  bool _mustKeepDeterministicReply(_SupportReply draftReply) {
    final String lower = draftReply.message.toLowerCase();

    if (lower.contains("what kind of hotline do you mean") ||
        lower.contains("i don't know which hotline you mean") ||
        lower.contains("i don't know that exact hotline") ||
        lower.contains("sources for what exactly") ||
        lower.contains("i don't know which source you mean") ||
        lower.contains("for police help, the number is") ||
        lower.contains("for ambulance help, the number is") ||
        lower.contains("for general emergency help, the number is") ||
        lower.contains("for the student or child helpline, the number is") ||
        lower.contains("i can't help with generic questions")) {
      return true;
    }
    return false;
  }

  bool _isGroqReplyCompliant({
    required _SupportReply fallbackReply,
    required _SupportReply candidate,
    required String userText,
  }) {
    final String candidateLower = candidate.message.toLowerCase();

    if (candidate.suggestionIds.length > 2) return false;

    if (candidate.message.contains('\n-') ||
        candidate.message.contains('\n•') ||
        candidateLower.contains("first,") && candidateLower.contains("then,")) {
      return false;
    }

    if (candidate.message.contains('?') ||
        candidateLower.contains("what's going on") ||
        candidateLower.contains("how can i support you")) {
      return false;
    }

    final List<String> forbiddenGenericTokens = [
      "math",
      "algebra",
      "geography",
      "physics",
      "chemistry",
      "history lesson",
      "search result",
      "wikipedia",
    ];
    if (forbiddenGenericTokens.any(candidateLower.contains)) {
      return false;
    }

    return true;
  }

  bool _containsPattern(String text, String pattern) {
    final String escapedPattern =
        RegExp.escape(pattern).replaceAll(r'\ ', r'\s+');
    final RegExp matcher = RegExp(
      '(^|[^a-z0-9])$escapedPattern([^a-z0-9]|\$)',
      caseSensitive: false,
    );
    return matcher.hasMatch(text);
  }

  bool _containsAny(String text, List<String> patterns) {
    return patterns.any((pattern) => _containsPattern(text, pattern));
  }

  bool _startsWithAny(String text, List<String> prefixes) {
    return prefixes.any((prefix) => text.startsWith(prefix));
  }

  _SupportReply _buildJournalWelcomeReply(String journalText, String sessionIntro) {
    if (journalText.trim().isEmpty) {
      return _SupportReply(
        message:
            "$sessionIntro Thanks for opening up in your journal. How are you feeling today?",
        suggestionIds: [],
      );
    }

    final _SupportReply baseReply = _buildSupportReply(journalText);
    return _SupportReply(
      message: "$sessionIntro Thanks for sharing that in your journal. ${baseReply.message}",
      suggestionIds: [],
    );
  }

  _SupportReply _buildSupportReply(String text) {
    final String normalized = text
        .toLowerCase()
        .replaceAll(String.fromCharCode(0x2019), "'")
        .replaceAll('`', "'")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();
    final _SupportReply? pendingReply = _handlePendingClarification(normalized);
    if (pendingReply != null) {
      return pendingReply;
    }

    final bool explicitSelfHarmRequest = normalized == "die" ||
        _containsAny(normalized, [
          "suicide",
          "self-harm",
          "self harm",
          "kill myself",
          "want to die",
          "need to die",
          "should die",
          "end my life",
          "take my life",
        ]);
    if (explicitSelfHarmRequest) {
      return _buildSpecificHotlineReply(normalized) ??
          const _SupportReply(
            message:
                "For suicide or self-harm support, call 9152987821 right now. There are people ready to help you. Please also contact a friend or a trusted adult immediately.",
            suggestionIds: [],
          );
    }

    final bool abusiveOrHostile = _containsAny(normalized, [
      "idiot",
      "stupid",
      "dumb",
      "shut up",
      "useless",
      "hate you",
      "annoying",
    ]);
    if (abusiveOrHostile) {
      return const _SupportReply(
        message:
            "I'm still here for you. If you're feeling upset right now, take a short break and do a few slow breaths to steady yourself.",
        suggestionIds: ["meditation"],
      );
    }

    final bool mentionsHotline = _containsAny(normalized, [
      "hotline",
      "helpline",
      "help line",
      "help-line",
      "number to call",
      "call number",
      "support number",
      "phone number",
      "contact number",
      "emergency number",
      "helpline number",
    ]) ||
        (_containsAny(normalized, ["number", "call", "contact"]) &&
            _containsAny(normalized, [
              "police",
              "ambulance",
              "medical",
              "hospital",
              "emergency",
              "child",
              "student",
              "kid",
              "teen",
              "stalking",
              "eve teasing",
              "obscene call",
              "harassment",
            ]));
    final bool asksForSources = _containsAny(normalized, [
      "source",
      "sources",
      "reference",
      "references",
      "citation",
      "citations",
    ]);
    if (mentionsHotline) {
      final _SupportReply? specificHotlineReply =
          _buildSpecificHotlineReply(normalized);
      if (specificHotlineReply != null) {
        return specificHotlineReply;
      }
      if (_needsHotlineClarification(normalized)) {
        _pendingClarification = _PendingClarification.hotline;
        return const _SupportReply(
          message:
              "What kind of hotline do you mean? If you are not sure, I don't know which one to give, so please contact a friend or a trusted adult.",
          suggestionIds: [],
        );
      }
      return const _SupportReply(
        message:
            "I don't know which hotline you mean. Please contact a friend or a trusted adult.",
        suggestionIds: [],
      );
    }
    if (asksForSources) {
      final _SupportReply? specificSourceReply =
          _buildSpecificSourceReply(normalized);
      if (specificSourceReply != null) {
        return specificSourceReply;
      }
      if (_needsSourceClarification(normalized)) {
        _pendingClarification = _PendingClarification.source;
        return const _SupportReply(
          message:
              "Sources for what exactly? If you do not mean bullying, feelings, or helping a friend, I do not know, so please contact a friend or a trusted adult.",
          suggestionIds: [],
        );
      }
      return const _SupportReply(
        message:
            "I don't know which source you mean. Please contact a friend or a trusted adult.",
        suggestionIds: [],
      );
    }

    if (_consecutiveSuggestionRejections >= 2) {
      return const _SupportReply(
        message:
            "Got it. Let's skip suggestions for now. Please take a short break and do slow breathing for a minute. Keep doing that for a little while - it can help you feel better.",
        suggestionIds: [],
      );
    }

    if (_consecutiveSuggestionRejections == 1) {
      if (!_lastSuggestedIds.contains("coloring")) {
        return const _SupportReply(
          message:
              "Okay, thanks for telling me. Let's try something different - maybe a quick game break with coloring, or just do something you enjoy for a few minutes.",
          suggestionIds: ["coloring"],
        );
      }
      return const _SupportReply(
        message:
            "Okay, thanks for telling me. We can skip cards for now. Please take a short break, breathe slowly, and keep doing that for a little while - it can help you feel better.",
        suggestionIds: [],
      );
    }

    final bool mentionsImmediateDanger = _containsAny(normalized, [
      "unsafe",
      "not safe",
      "scared to go",
      "threat",
      "threatened",
      "stalking",
      "follow me",
      "following me",
      "hit me",
      "hurt me",
      "blackmail",
    ]);
    final bool mentionsFriendConcern = _containsAny(normalized, [
          "my friend",
          "friend is",
          "friend was",
          "someone else",
          "my classmate",
        ]) &&
        _containsAny(normalized, [
          "bullied",
          "bully",
          "hurt",
          "sad",
          "unsafe",
          "scared",
        ]);
    final bool mentionsBullying = _containsAny(normalized, [
      "bully",
      "bullied",
      "making fun",
      "tease",
      "teasing",
      "harass",
      "mock",
      "picked on",
      "exclude",
      "rumor",
      "classmates",
    ]);
    final bool mentionsAnxiety = _containsAny(normalized, [
      "anxious",
      "anxiety",
      "panic",
      "panicking",
      "stressed",
      "stress",
      "overthinking",
      "overwhelmed",
      "can't calm down",
      "cannot calm down",
      "heart is racing",
      "nervous",
      "relax",
      "clear my head",
    ]);
    final bool mentionsSadness = _containsAny(normalized, [
      "depressed",
      "sad",
      "down",
      "lonely",
      "empty",
      "hopeless",
      "worthless",
      "no one cares",
      "feel alone",
      "tired of everything",
      "crying",
    ]);
    final bool mentionsConfidence = _containsAny(normalized, [
      "not good enough",
      "can't do anything",
      "bad at everything",
      "no confidence",
      "hate myself",
      "i'm useless",
      "i am useless",
      "i'm a failure",
      "i am a failure",
    ]);
    final bool mentionsAnger = _containsAny(normalized, [
      "angry",
      "mad",
      "frustrated",
      "annoyed",
      "rage",
      "furious",
      "irritated",
    ]);
    final bool wantsDistraction = _containsAny(normalized, [
      "distract",
      "take my mind off",
      "unwind",
      "relax",
      "calm down",
      "stop thinking",
      "clear my head",
    ]);
    final bool asksGenericQuestion = _isOffTopicRequest(normalized) ||
        (_looksLikeGeneralQuestion(normalized) &&
            !_containsAny(normalized, [
              "feel better",
              "feeling",
              "feelings",
              "sad",
              "depressed",
              "anxious",
              "anxiety",
              "panic",
              "stressed",
              "stress",
              "bully",
              "bullied",
              "bullying",
              "friend",
              "trusted adult",
              "unsafe",
              "scared",
              "walk",
              "draw",
              "journal",
              "meditate",
              "meditation",
              "calm down",
              "clear my head",
              "relax",
              "cope",
              "help me feel",
            ]));

    if (asksGenericQuestion) {
      return const _SupportReply(
        message:
            "I can't help with generic questions. I can only suggest ways to help you feel a little better, like talking to a friend or a trusted adult, taking a short walk, drawing, journaling, or meditating.",
        suggestionIds: ["journal", "meditation", "coloring"],
      );
    }

    if (mentionsImmediateDanger) {
      return const _SupportReply(
        message:
            "If you feel unsafe right now, please move toward a safer place first and tell a trusted adult or friend right away. After that, you can write down what happened so you do not have to hold it all in your head.",
        suggestionIds: ["journal"],
      );
    }

    if (mentionsFriendConcern) {
      return const _SupportReply(
        message:
            "If this is about a friend, check in gently, listen without pushing, and help them tell a trusted adult. You can also write down what you want to say first.",
        suggestionIds: ["journal"],
      );
    }

    if (mentionsBullying) {
      return const _SupportReply(
        message:
            "That sounds upsetting. Start by telling a trusted adult, save or write down what happened, and take one small calming break like a short walk or a few slow breaths.",
        suggestionIds: ["questionnaire", "journal"],
      );
    }

    if (mentionsAnxiety) {
      return const _SupportReply(
        message:
            "I'm really glad you told me this. Please talk to a friend first so you are not carrying this alone, and then talk to a trusted adult or seek professional help because asking for help is important. After that, try a short meditation or a few slow breaths to calm yourself.",
        suggestionIds: ["meditation", "journal"],
      );
    }

    if (mentionsAnger) {
      return const _SupportReply(
        message:
            "Before reacting, take a short walk, draw for a bit, or pause with a calming exercise so your mind can cool down. If it still feels heavy after that, talk to a friend or a trusted adult.",
        suggestionIds: ["coloring", "journal", "meditation"],
      );
    }

    if (mentionsSadness || mentionsConfidence) {
      return const _SupportReply(
        message:
            "I'm really glad you shared this with me. Please talk to a friend first so you are not sitting with this alone, and then talk to a trusted adult or seek professional help because your feelings matter. After that, try a short meditation or a calm walk.",
        suggestionIds: ["meditation", "journal"],
      );
    }

    if (wantsDistraction) {
      return const _SupportReply(
        message:
            "A gentle reset can help. You could take a short walk, draw for a few minutes, try a short meditation, or write a little and come back when your thoughts feel lighter.",
        suggestionIds: ["meditation", "coloring", "journal"],
      );
    }

    return const _SupportReply(
      message:
          "We can keep this simple. Talk to a friend or a trusted adult, take a short walk, draw for a bit, write in your journal, or try a short meditation.",
      suggestionIds: ["journal", "meditation", "coloring"],
    );
  }

  _SupportReply? _handlePendingClarification(String normalized) {
    if (_pendingClarification == null) return null;

    final _PendingClarification pending = _pendingClarification!;
    _pendingClarification = null;

    if (pending == _PendingClarification.hotline) {
      return _buildSpecificHotlineReply(normalized) ??
          const _SupportReply(
            message:
                "I don't know which hotline you mean. Please contact a friend or a trusted adult.",
            suggestionIds: [],
          );
    }

    return _buildSpecificSourceReply(normalized) ??
        const _SupportReply(
          message:
              "I don't know which source you mean. Please contact a friend or a trusted adult.",
          suggestionIds: [],
        );
  }

  _SupportReply? _buildSpecificHotlineReply(String normalized) {
    if (_containsAny(normalized, [
      "suicide",
      "self-harm",
      "self harm",
      "kill myself",
      "want to die",
      "need to die",
      "should die",
    ])) {
      return const _SupportReply(
        message:
            "For suicide or self-harm support, call 9152987821 right now. There are people ready to help you. Please also contact a friend or a trusted adult immediately.",
        suggestionIds: [],
      );
    }

    if (_containsAny(normalized, ["police", "cop", "law"])) {
      return const _SupportReply(
        message: "For police help, the number is 100.",
        suggestionIds: [],
      );
    }

    if (_containsAny(normalized, ["ambulance", "medical", "hospital"])) {
      return const _SupportReply(
        message: "For ambulance help, the number is 102.",
        suggestionIds: [],
      );
    }

    if (_containsAny(normalized, ["emergency", "urgent", "immediate danger", "112"])) {
      return const _SupportReply(
        message: "For general emergency help, the number is 112.",
        suggestionIds: [],
      );
    }

    if (_containsAny(normalized, ["child", "student", "kid", "teen"])) {
      return const _SupportReply(
        message: "For the student or child helpline, the number is 1098.",
        suggestionIds: [],
      );
    }

    if (_containsAny(normalized, ["stalking", "eve teasing", "obscene call", "harassment"])) {
      return const _SupportReply(
        message:
            "For eve teasing, obscene calls, or stalking, the number is 1096. The alternate number is +91 1127894455.",
        suggestionIds: [],
      );
    }

    return null;
  }

  _SupportReply? _buildSpecificSourceReply(String normalized) {
    if (normalized == "friend" ||
        _containsAny(normalized, [
          "help a friend",
          "friend who is bullied",
          "friend being bullied",
          "friend is bullied",
          "friend is sad",
          "friend is unsafe",
          "my friend needs help",
          "my friend is bullied",
          "my friend is sad",
          "my friend is unsafe",
        ])) {
      return const _SupportReply(
        message:
            "For this, I can suggest support steps in chat, journaling, meditation, or talking to a trusted adult.",
        suggestionIds: ["journal", "meditation"],
      );
    }

    if (_containsAny(normalized, ["bully", "bullied", "bullying", "teasing"])) {
      return const _SupportReply(
        message:
            "For bullying support, I can suggest chat steps, journaling, and the bullying quiz.",
        suggestionIds: ["questionnaire", "journal"],
      );
    }

    if (_containsAny(normalized, [
      "sad",
      "depression",
      "depressed",
      "anxiety",
      "anxious",
      "stress",
      "feelings",
      "emotion",
      "emotions",
      "mental health",
    ])) {
      return const _SupportReply(
        message:
            "For heavy feelings, I can suggest meditation, journaling, and talking to someone you trust.",
        suggestionIds: ["meditation", "journal"],
      );
    }

    return null;
  }

  bool _needsHotlineClarification(String normalized) {
    if (_containsAny(normalized, [
      "hotline",
      "helpline",
      "help line",
      "help-line",
      "hotline number",
      "helpline number",
    ])) {
      return normalized.trim().split(RegExp(r"\s+")).length <= 2;
    }

    return _containsAny(normalized, [
          "need a hotline",
          "need hotline",
          "give me a hotline",
          "give me hotline",
          "show me hotline",
          "show me helpline",
          "what hotline",
          "which hotline",
        ]) &&
        !_containsAny(normalized, ["for", "about"]);
  }

  bool _needsSourceClarification(String normalized) {
    if (_containsAny(normalized, [
      "source",
      "sources",
      "reference",
      "references",
      "citation",
      "citations",
    ])) {
      return normalized.trim().split(RegExp(r"\s+")).length <= 2;
    }

    return _containsAny(normalized, [
          "give me sources",
          "show me sources",
          "what sources",
          "which source",
          "need sources",
        ]) &&
        !_containsAny(normalized, ["for", "about", "on"]);
  }

  bool _isOffTopicRequest(String normalized) {
    const List<String> offTopicKeywords = [
      "math",
      "maths",
      "mathematics",
      "algebra",
      "equation",
      "calculate",
      "solve",
      "english",
      "grammar",
      "translate",
      "translation",
      "search",
      "google",
      "find me",
      "look up",
      "weather",
      "capital of",
      "history",
      "science",
      "chemistry",
      "physics",
      "essay",
      "homework",
      "classwork",
      "programming",
      "code",
      "debug",
      "website",
      "browser",
      "internet",
      "news",
      "spell",
      "spelling",
      "definition",
      "define",
      "summary",
      "summarize",
    ];

    return _containsAny(normalized, offTopicKeywords);
  }

  bool _looksLikeGeneralQuestion(String normalized) {
    return _startsWithAny(normalized, const [
      "what is",
      "what are",
      "who is",
      "who are",
      "where is",
      "where are",
      "when is",
      "when are",
      "why is",
      "why are",
      "how do i",
      "how can i",
      "can you",
      "could you",
      "would you",
      "will you",
      "tell me",
      "show me",
      "find",
      "search",
      "give me",
      "write",
      "solve",
      "translate",
      "define",
      "explain",
    ]);
  }

  List<Map<String, String>> _buildSuggestions(List<String> suggestionIds) {
    final List<Map<String, String>> suggestions = [];

    for (final String id in suggestionIds) {
      final Map<String, String>? suggestion = _suggestionForId(id);
      if (suggestion == null) continue;
      if (suggestions.any((existing) => existing['id'] == id)) continue;
      suggestions.add(suggestion);
      if (suggestions.length >= 2) break;
    }

    return suggestions;
  }

  Map<String, String>? _suggestionForId(String id) {
    switch (id) {
      case "journal":
        return {
          "id": "journal",
          "title": "Open Journal",
          "subtitle": "Write down what you are feeling",
          "iconKey": "journal",
        };
      case "meditation":
        return {
          "id": "meditation",
          "title": "Calm Down Space",
          "subtitle": "Take a short breathing break",
          "iconKey": "meditation",
        };
      case "puzzle":
        return {
          "id": "puzzle",
          "title": "Puzzle",
          "subtitle": "Take a focused brain break",
          "iconKey": "puzzle",
        };
      case "memory_flip":
        return {
          "id": "memory_flip",
          "title": "Memory Flip",
          "subtitle": "Play a quick memory game",
          "iconKey": "memory_flip",
        };
      case "daily_challenges":
        return {
          "id": "daily_challenges",
          "title": "Daily Challenges",
          "subtitle": "Try one small confidence step",
          "iconKey": "daily_challenges",
        };
      case "coloring":
        return {
          "id": "coloring",
          "title": "Coloring Book",
          "subtitle": "Take a gentle break",
          "iconKey": "coloring",
        };
      // case "talk_to_chair":
      //   return {
      //     "id": "talk_to_chair",
      //     "title": "Talk to the Chair",
      //     "subtitle": "Let your feelings out safely",
      //     "iconKey": "talk",
      //   };
      case "questionnaire":
        return {
          "id": "questionnaire",
          "title": "Bullying Quiz",
          "subtitle": "Understand what is happening",
          "iconKey": "questionnaire",
        };
    }

    return null;
  }

  /*
  Legacy guided-flow helpers are kept here for reference while the chat now
  uses the deterministic support replies above.

  String? _detectGuidedFlowIntent(String text) {
    final String t = text.toLowerCase();

    if (_containsAny(t, [
      "bully",
      "bullied",
      "making fun",
      "tease",
      "teasing",
      "harass",
      "mock",
      "picked on",
      "school kids",
      "classmates",
    ])) {
      return "bullying";
    }

    if (_containsAny(t, [
      "depressed",
      "sad",
      "down",
      "lonely",
      "empty",
      "hopeless",
      "worthless",
      "no one cares",
      "feel alone",
      "tired of everything",
    ])) {
      return "sadness";
    }

    if (_containsAny(t, [
      "anxious",
      "anxiety",
      "panic",
      "panicking",
      "stressed",
      "stress",
      "overthinking",
      "overwhelmed",
      "can't calm down",
      "cannot calm down",
      "my heart is racing",
      "nervous",
    ])) {
      return "anxiety";
    }

    if (_containsAny(t, [
      "not good enough",
      "can't do anything",
      "bad at everything",
      "no confidence",
      "hate myself",
      "i'm useless",
      "i am useless",
      "i'm a failure",
      "i am a failure",
    ])) {
      return "confidence";
    }

    return null;
  }

  bool _isActionSeekingMessage(String text) {
    final String t = text.toLowerCase();
    return _containsAny(t, [
      "what should i do",
      "what do i do",
      "what can i do",
      "how do i",
      "help me",
      "give me advice",
      "what now",
      "next step",
      "how can i stop",
      "how to stop",
    ]);
  }

  String _buildGuidedFlowReply(String latestUserText) {
    final String flow = _activeGuidedFlow ?? "";
    final bool actionSeeking = _isActionSeekingMessage(latestUserText);
    String response;

    if (flow == "bullying") {
      if (actionSeeking) {
        response =
            "You can start with one small step: move closer to someone safe, save what happened if it was online, and tell one trusted adult today. If you want, we can pick who to talk to first.";
        _activeGuidedFlow = null;
        _guidedFlowStep = 0;
        return response;
      }
      if (_guidedFlowStep == 0) {
        response =
            "That sounds really hurtful. Do you want to tell me what happened?";
      } else if (_guidedFlowStep == 1) {
        response =
            "Thank you for sharing that with me. Was it something someone said, did, or posted?";
      } else if (_guidedFlowStep == 2) {
        response =
            "How has this been making you feel lately? If you want, we can also think of one small next step together.";
      } else {
        response =
            "You deserve support. We could try a quick journal entry, or think of one trusted person you can talk to.";
        _activeGuidedFlow = null;
      }
    } else if (flow == "sadness") {
      if (actionSeeking) {
        response =
            "A gentle plan that can help right now is: take 10 slow breaths, drink some water, then do one tiny thing like a short walk or writing 2 lines about what you feel. If you want, we can do the first step together.";
        _activeGuidedFlow = null;
        _guidedFlowStep = 0;
        return response;
      }
      if (_guidedFlowStep == 0) {
        response =
            "I’m really sorry you’re feeling this way. It can be really hard to carry those feelings. Do you want to share what’s been making things feel this way?";
      } else if (_guidedFlowStep == 1) {
        response =
            "Thank you for telling me. When these feelings show up, what part feels the heaviest for you?";
      } else if (_guidedFlowStep == 2) {
        response =
            "That makes a lot of sense. Sometimes talking it out or writing it down can ease the pressure a little.";
      } else {
        response =
            "If you want, we can do one small step now: a short breathing break, or a quick journal note about what you need most tonight.";
        _activeGuidedFlow = null;
      }
    } else if (flow == "anxiety") {
      if (actionSeeking) {
        response =
            "Let’s do something simple right now: breathe in for 4, hold for 4, and breathe out for 6 for one minute. Then name 5 things you can see around you to help your body feel safer.";
        _activeGuidedFlow = null;
        _guidedFlowStep = 0;
        return response;
      }
      if (_guidedFlowStep == 0) {
        response =
            "That sounds really overwhelming. I’m glad you told me. Do you want to share what feels most intense right now?";
      } else if (_guidedFlowStep == 1) {
        response =
            "Thank you for sharing that. When this starts, where do you feel it most in your body - chest, breathing, or somewhere else?";
      } else if (_guidedFlowStep == 2) {
        response =
            "We can take this one small step at a time. If you want, we can try a short breathing break together for a minute.";
      } else {
        response =
            "You’re doing your best in a hard moment. If it helps, you could try a short meditation now, then come back and tell me how you feel.";
        _activeGuidedFlow = null;
      }
    } else {
      if (actionSeeking) {
        response =
            "A good first step is to pick one tiny thing you can complete in 5 minutes, then pause and notice that you did it. Small wins can help your confidence grow.";
        _activeGuidedFlow = null;
        _guidedFlowStep = 0;
        return response;
      }
      if (_guidedFlowStep == 0) {
        response =
            "I’m glad you told me. Feeling this way can be heavy. Do you want to share a moment that made you feel this about yourself?";
      } else if (_guidedFlowStep == 1) {
        response =
            "Thanks for opening up. What would you say to a friend if they were feeling exactly like this?";
      } else if (_guidedFlowStep == 2) {
        response =
            "You’re not alone in this. Even small wins count. Can we pick one tiny thing you did okay today?";
      } else {
        response =
            "You matter more than this moment is telling you. If you want, we can keep talking or write one kind sentence to yourself in your journal.";
        _activeGuidedFlow = null;
      }
    }

    _guidedFlowStep += 1;
    return response;
  }

  bool _hasNegationNearKeyword(String text, List<String> keywords) {
    final String t = text.toLowerCase();
    final List<String> negations = [
      "don't",
      "dont",
      "do not",
      "not",
      "no",
      "never",
      "stop",
      "avoid",
      "can't",
      "cannot",
      "wont",
      "won't",
    ];
    for (final keyword in keywords) {
      if (!t.contains(keyword)) continue;
      for (final negation in negations) {
        if (t.contains("$negation $keyword") || t.contains("$keyword $negation")) {
          return true;
        }
      }
    }
    return false;
  }

  List<Map<String, String>> _buildFeatureSuggestions({
    required String userText,
    required String botReply,
    String? activeFlow,
  }) {
    final String user = userText.toLowerCase();
    final String reply = botReply.toLowerCase();
    final List<Map<String, String>> suggestions = [];

    void addSuggestion(String id, String title, String subtitle, String iconKey) {
      if (suggestions.any((s) => s['id'] == id)) return;
      suggestions.add({
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'iconKey': iconKey,
      });
    }

    final bool userRejectsWriting = _hasNegationNearKeyword(user, [
      'write',
      'writing',
      'journal',
      'note',
      'notes',
    ]);
    final bool userRejectsBreathing = _hasNegationNearKeyword(user, [
      'breathe',
      'breathing',
      'meditation',
      'calm',
    ]);
    final bool userRejectsChallenges = _hasNegationNearKeyword(user, [
      'challenge',
      'step',
      'task',
    ]);

    final bool replyHintsJournal = _containsAny(reply, [
      'journal',
      'write',
      'writing',
      'note',
      'write this down',
    ]);
    final bool replyHintsMeditation = _containsAny(reply, [
      'meditation',
      'breathe',
      'breathing',
      'calm',
      'breathing break',
    ]);
    final bool replyHintsChallenge = _containsAny(reply, [
      'challenge',
      'small step',
      'tiny step',
      'one step',
    ]);
    final bool replyHintsInfo = _containsAny(reply, [
      'learn',
      'guide',
      'bullying',
      'bystander',
      'support tips',
    ]);

    if (!userRejectsWriting &&
        replyHintsJournal) {
      addSuggestion(
        'journal',
        'Open Journal',
        'Write what you are feeling',
        'journal',
      );
    }

    if (!userRejectsBreathing &&
        replyHintsMeditation) {
      addSuggestion(
        'meditation',
        'Try Meditation',
        'Take a short calming break',
        'meditation',
      );
    }

    if (!userRejectsChallenges &&
        replyHintsChallenge) {
      addSuggestion(
        'challenge',
        'Daily Challenge',
        'Pick one confidence step',
        'challenge',
      );
    }

    if (replyHintsInfo) {
      addSuggestion(
        'info',
        'Information Module',
        'Read practical guidance',
        'info',
      );
    }


    if (suggestions.length > 2) {
      return suggestions.sublist(0, 2);
    }

    return suggestions;
  }
  */

  void _openSuggestedFeature(Map<String, String> suggestion) {
    final String id = suggestion['id'] ?? '';
    Widget? destination;

    if (id == 'journal') {
      destination = Journal();
    } else if (id == 'meditation') {
      destination = MOptions();
    } else if (id == 'puzzle') {
      destination = POptions();
    } else if (id == 'memory_flip') {
      destination = FlipCardGame();
    } else if (id == 'daily_challenges') {
      destination = const ChallengeJourneyScreen();
    } else if (id == 'coloring') {
      destination = COptions();
    // } else if (id == 'talk_to_chair') {
    //   destination = const TalkToChairScreen();
    // } else if (id == 'questionnaire') {
    } else if (id == 'questionnaire') {
      destination = Questions();
    }

    if (destination == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destination!),
    );
  }

  void _appendBotMessage(
    String message, {
    List<Map<String, String>> suggestions = const [],
  }) {
    if (!mounted) return;
    _lastSuggestedIds = suggestions
        .map((s) => (s['id'] ?? '').trim())
        .where((id) => id.isNotEmpty)
        .toSet();
    setState(() {
      _messages.add(_createMessage(
        text: message,
        isUserMessage: false,
        suggestions: suggestions,
      ));
    });
  }

  Map<String, dynamic> _createMessage({
    required String text,
    required bool isUserMessage,
    bool isError = false,
    List<Map<String, String>> suggestions = const [],
  }) {
    return {
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'text': text,
      'isUserMessage': isUserMessage,
      'liked': false,
      'disliked': false,
      'isError': isError,
      'suggestions': suggestions,
    };
  }

  void _openReportSheet(BuildContext context, String contentId, String contentText) {
    final reasons = <String>[
      "Not nice / Rude",
      "Doesn’t make sense",
      "Too long",
      "Scary",
      "Other",
    ];
    String selectedReason = reasons.first;
    final TextEditingController notes = TextEditingController();

    showModalBottomSheet(
      backgroundColor: lightThemeColor,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                        SizedBox(
                          width: MediaQuery.of(ctx).size.width - 100,
                          child: const Text(
                            'Report chatbot message',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Thanks for your feedback. Let us know what's wrong.",
                            style: TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),

                          ...reasons.map((r) => RadioListTile<String>(
                            dense: true,
                            activeColor: themecolor,
                            title: Text(r, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            value: r,
                            groupValue: selectedReason,
                            onChanged: (v) => setModalState(() => selectedReason = v!),
                          )),

                          const SizedBox(height: 8),
                          const Text(
                            "Anything else you’d like to tell us?",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: notes,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Write here…',
                              hintStyle: TextStyle(fontSize: 14),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          FilledButton(
                            onPressed: () async {
                              await saveReport(
                                contentId: contentId,
                                contentText: contentText,
                                reason: selectedReason,
                                details: notes.text.trim(),
                                role: "bot",
                              );
                              if (context.mounted) {
                                Navigator.pop(ctx);
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(content: Text("Thanks. We’ll review this.")),
                                // );
                                const snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: '',
                                    message:
                                    'Thanks. We’ll review this.',
                                    contentType: ContentType.success,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themecolor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              minimumSize: const Size(double.infinity, 30),
                              elevation: 5,
                            ),
                            child: const Text(
                              "Submit",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> saveReport({
    required String contentId,
    required String contentText,
    required String reason,
    required String details,
    required String role,
    }) async {

  await FirebaseFirestore.instance.collection('reports').add({
    'contentId': contentId,
    'contentText': contentText,
    'role': role,
    'reason': reason,
    'details': details,
    'reportedAt': FieldValue.serverTimestamp(),
  });
  }

}

class _SupportReply {
  const _SupportReply({
    required this.message,
    required this.suggestionIds,
  });

  final String message;
  final List<String> suggestionIds;
}

class ChatMessage extends StatelessWidget {
  final String id;
  final String text;
  final bool isUserMessage;
  final List<Map<String, String>> suggestions;
  final void Function(Map<String, String>)? onSuggestionTap;

  final bool liked;
  final bool disliked;
  final void Function(bool like)? onFeedback;

  const ChatMessage({
    super.key,
    required this.id,
    required this.text,
    this.isUserMessage = false,
    this.suggestions = const [],
    this.onSuggestionTap,
    this.liked = false,
    this.disliked = false,
    this.onFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isUserMessage ? const Color(0xFFfbd45e) : const Color(0xFFffab77),
            borderRadius: isUserMessage
                ? const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            )
                : const BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        if (!isUserMessage && suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions.map((s) {
                final IconData icon = _suggestionIconForKey(s['iconKey']);
                return _SuggestionCard(
                  title: s['title'] ?? 'Open',
                  subtitle: s['subtitle'] ?? '',
                  icon: icon,
                  onTap: () => onSuggestionTap?.call(s),
                );
              }).toList(),
            ),
          ),
        if(!isUserMessage)
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, bottom: 6),
          child: Row(
            mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              IconButton(
                tooltip: 'Helpful',
                color: themecolor,
                icon: Icon(liked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined, size: 20),
                onPressed: () => onFeedback?.call(true),
              ),
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'Report',
                color: themecolor,
                icon: Icon(disliked ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined, size: 20),
                onPressed: () => onFeedback?.call(false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

IconData _suggestionIconForKey(String? key) {
  switch (key) {
    case 'journal':
      return Icons.book_rounded;
    case 'meditation':
      return Icons.self_improvement;
    case 'puzzle':
      return Icons.extension_rounded;
    case 'memory_flip':
      return Icons.grid_view_rounded;
    case 'daily_challenges':
      return Icons.flag_rounded;
    case 'coloring':
      return Icons.palette_rounded;
    case 'talk':
      return Icons.record_voice_over_rounded;
    case 'questionnaire':
      return Icons.fact_check_rounded;
    case 'info':
      return Icons.menu_book_rounded;
    case 'sos':
      return Icons.support_agent_rounded;
    default:
      return Icons.auto_awesome;
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: themecolor.withOpacity(0.45)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: themecolor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: Text(text, style: theme.textTheme.titleMedium),
        ),
      ],
    );
  }
}

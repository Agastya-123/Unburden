import '../secrets.dart';
import 'dart:convert';
import '/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groq/groq.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../ChatBot/chatbot.dart';
import '../utils/safety_check.dart';
import '../utils/safety_support_dialog.dart';

class Jentry extends StatefulWidget {
  @override
  State createState() => _JentryState();
}

class _JentryState extends State<Jentry> {
  TextEditingController journalController = TextEditingController();
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _lastRecognized = '';

  final groqConfiguration = Configuration(
    model: "llama-3.1-8b-instant",
    temperature: 0.7,
  );

  late final _groq = Groq(
    apiKey: Secrets.groqApiKey,
    configuration: groqConfiguration,
  );

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _groq.startChat();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (_lastRecognized.isNotEmpty) {
        final before = journalController.text;
        journalController.text = before.isEmpty
            ? _lastRecognized
            : '$before $_lastRecognized';
        _lastRecognized = '';
      }
      setState(() => _isListening = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to journal.')),
        );
      }
      return;
    }
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (mounted && (status == 'done' || status == 'notListening')) {
            setState(() => _isListening = false);
            if (_lastRecognized.isNotEmpty) {
              final before = journalController.text;
              journalController.text = before.isEmpty
                  ? _lastRecognized
                  : '$before $_lastRecognized';
              _lastRecognized = '';
            }
          }
        },
        onError: (_) => setState(() => _isListening = false),
      );
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Speech not available on this device.')),
          );
        }
        return;
      }
      _lastRecognized = '';
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            setState(() => _lastRecognized = result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
      );
    } on MissingPluginException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Voice input not set up. Stop the app, run: flutter clean && flutter pub get, then run again.',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Voice input failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> saveJournal(String content, String tone, String emotion, String triggeringWord) async {
    try {
      final journalsBox = Hive.box('journals');
      
      String journalId = DateTime.now().millisecondsSinceEpoch.toString();
      Map<String, dynamic> journal = {
        'id': journalId,
        'uid': user?.uid ?? '',
        'title': content.length > 20 ? content.substring(0, 20) + "..." : content,
        'content': content,
        'tone': tone,
        'emotion': emotion,
        'triggering': triggeringWord,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      await journalsBox.put(journalId, journal);
      print("Journal saved successfully to Hive!");
    } catch (e) {
      print("Error saving journal: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isListening ? "Listening..." : ""),
        backgroundColor: themecolor,
        actions: [
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : Colors.white,
            ),
            onPressed: _toggleListening,
            tooltip: 'Speak to add text',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Image.asset("assets/journal_frame.png",),
                  ),
                  Positioned(
                    top: 120,
                    left: 30,
                    right: 30,
                    bottom: 120,
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: journalController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: "Write your journal entry here...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (journalController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please write something first!')),
                    );
                    return;
                  }
        
                  String journalText = journalController.text.trim();
        
                  try {
                    final bool safetyTriggered = await SafetyCheck.performSafetyCheck(
                      text: journalText,
                      context: "journal",
                    );
                    if (safetyTriggered) {
                      await SafetySupportDialog.show(context);
                      return;
                    }

                    GroqResponse response = await _groq.sendMessage(
                        "$journalText This is the user journal. Check the tone of the message (Positive or Negative), the emotion of the journal, and detect any triggering words (e.g., bullying). Respond ONLY in valid JSON format without any extra text. Your response should strictly follow this format: {\"tone\": \"Positive/Negative\", \"emotion\": \"Happy/Sad/Angry/etc.\", \"triggering\": \"word_if_any_else_null\"}."
                    );
        
                    String responseText = response.choices.first.message.content.trim();
                    Map<String, dynamic> responseJson = jsonDecode(responseText);
        
                    String tone = responseJson['tone'] ?? "Unknown";
                    String emotion = responseJson['emotion'] ?? "Unknown";
                    String triggeringWord = responseJson['triggering'] ?? "null";
        
                    await saveJournal(journalText, tone, emotion, triggeringWord);
        
                    if (tone.toLowerCase().contains("negative")) {
                      chatbotDialog(context, "You seem $emotion.\nWant to talk about it?", responseText);
                    } else {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    print("Error parsing or saving: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error occurred. Try again.')),
                    );
                  }
                },
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themecolor,
                  foregroundColor: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void chatbotDialog(BuildContext context, String text, String response) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Ray's Here",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
        ),
        content: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: Column(
              children: [
                Image.asset("assets/ray.png", width: 150, height: 150),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChatScreen(task: "journal", text: response)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: themecolor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Yes, let's talk.",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: themecolor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "No, maybe later.",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

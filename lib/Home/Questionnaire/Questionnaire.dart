import '/Home/Questionnaire/QuestionnaireResults.dart';
import 'package:flutter/material.dart';
import '/colors.dart';

class Questions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  bool _showIntro = true;

  static const List<Map<String, String>> _responseOptions = [
    {'label': '😊 Never', 'value': 'Never'},
    {'label': '🙂 Rarely', 'value': 'Rarely'},
    {'label': '😐 Sometimes', 'value': 'Sometimes'},
    {'label': '😟 Often', 'value': 'Often'},
    {'label': '😢 Very Often', 'value': 'Very Often'},
  ];

  List<dynamic> questions = [
    [
      "Do people make hurtful comments or tease you in a way that makes you feel bad?",
      "Do people imitate you or make fun of your appearance, voice, or the way you act?",
    ],
    [
      "Are people spreading rumors or false information about you?",
      "Are you being harassed online or receiving mean messages, posts, or comments?",
    ],
    [
      "Have your belongings ever been taken, hidden, or damaged without your permission?",
      "Has anyone pushed, shoved, or touched you in a way that made you uncomfortable?",
    ],
    [
      "Do you feel left out or excluded by classmates or friends?",
      "Do you ever feel afraid or uncomfortable going to places where these people might be?",
    ],
    [
      "Have you felt hesitant to talk about these experiences with a trusted adult or friend?",
      "Do you feel safe and respected at school or at home?",
    ],
  ];

  String options_1 = "";
  String options_2 = "";
  int index = 0;

  List<String> responses = [];

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return Scaffold(
        backgroundColor: lightThemeColor,
        appBar: AppBar(
          backgroundColor: themecolor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Image.asset("assets/ray.png", width: 140, height: 140),
                ),
                const SizedBox(height: 24),
                Text(
                  "Let's check in",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: themecolor.withOpacity(0.35)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Answer a few questions about your recent experiences.\n\n"
                        "This will help you reflect on how you're feeling.\n\n"
                        "This is a simple check-in to help you understand your experiences - not a diagnosis.",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _showIntro = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themecolor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Start",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    }

    const int totalQuestions = 10;
    final int questionsSoFar = index * 2;
    final int currentRangeStart = index * 2 + 1;
    final int currentRangeEnd = (index * 2 + 2).clamp(0, totalQuestions);

    return Scaffold(
      backgroundColor: lightThemeColor,
      appBar: AppBar(
        backgroundColor: themecolor,
        elevation: 0,
        title: Text(
          "Question $currentRangeStart–$currentRangeEnd of $totalQuestions",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: LinearProgressIndicator(
              value: questionsSoFar / totalQuestions,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (questions[index][0].toString().isNotEmpty) ...[
                Text(
                  questions[index][0],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                ),
                getOptions(1),
              ],
              const SizedBox(height: 20),
              if (questions[index][1].toString().isNotEmpty) ...[
                Text(
                  questions[index][1],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                ),
                getOptions(2),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (options_1.isNotEmpty) responses.add(options_1);
                      if (options_2.isNotEmpty) responses.add(options_2);
                      options_1 = "";
                      options_2 = "";
                      if (index != 4) {
                        index++;
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuestionnaireResult(responses: responses)),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themecolor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: Text(
                    index != 4 ? "Next" : "Check Results",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getOptions(int whichOne) {
    final groupValue = whichOne == 1 ? options_1 : options_2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _responseOptions.map((opt) {
        final value = opt['value']!;
        final label = opt['label']!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                if (whichOne == 1) options_1 = value;
                else options_2 = value;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: (v) {
                    setState(() {
                      if (whichOne == 1) options_1 = v!;
                      else options_2 = v!;
                    });
                  },
                  activeColor: themecolor,
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
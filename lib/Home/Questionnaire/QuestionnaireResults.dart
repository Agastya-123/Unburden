import 'package:flutter/material.dart';
import '/colors.dart';
import '/ChatBot/chatbot.dart';

class QuestionnaireResult extends StatefulWidget {
  final List<String> responses;

  const QuestionnaireResult({Key? key, required this.responses})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => QuestionnaireResultState();
}

class QuestionnaireResultState extends State<QuestionnaireResult> {
  static const List<int> _weights = [1, 1, 2, 2, 2, 3, 2, 3, 1, 2];
  static const int _reverseStartIndex = 8;
  static const List<int> _redFlagIndices = [5, 7];
  static const int _maxWeightedScore = 76;
  static const int _thresholdBullying = 16;
  static const int _thresholdSerious = 40;

  int _optionToPoints(String option) {
    switch (option) {
      case 'Never':
        return 0;
      case 'Rarely':
        return 1;
      case 'Sometimes':
        return 2;
      case 'Often':
        return 3;
      case 'Very Often':
        return 4;
      default:
        return 0;
    }
  }

  int _getWeightedScore(List<String> responses) {
    int sum = 0;
    for (int i = 0; i < responses.length && i < _weights.length; i++) {
      int points = _optionToPoints(responses[i]);
      if (i >= _reverseStartIndex) {
        points = 4 - points;
      }
      sum += _weights[i] * points;
    }
    return sum;
  }

  int _getRedFlagCount(List<String> responses) {
    int count = 0;
    for (int i in _redFlagIndices) {
      if (i < responses.length) {
        final points = _optionToPoints(responses[i]);
        if (points >= 3) count++;
      }
    }
    return count;
  }

  /// Same logic as result labels: 0 = things okay, 1 = bullying, 2 = serious.
  int _outcomeBucket(int weightedScore, int redFlagCount) {
    if (redFlagCount >= 2 || weightedScore >= _thresholdSerious) return 2;
    if (redFlagCount >= 1 || weightedScore >= _thresholdBullying) return 1;
    return 0;
  }

  /// Bar has 3 segments. Marker position in [0,1].
  double _markerPositionForBar(int weightedScore, int bucket) {
    switch (bucket) {
      case 0:
        return (weightedScore / _thresholdBullying).clamp(0.0, 1.0) * (1 / 3);
      case 1:
        return (1 / 3) +
            ((weightedScore - _thresholdBullying) / (_thresholdSerious - _thresholdBullying))
                .clamp(0.0, 1.0) *
                (1 / 3);
      case 2:
        return (2 / 3) +
            ((weightedScore - _thresholdSerious) / (_maxWeightedScore - _thresholdSerious))
                .clamp(0.0, 1.0) *
                (1 / 3);
      default:
        return 0.5;
    }
  }

  Widget _buildSeverityBar(int weightedScore, int redFlagCount) {
    final int bucket = _outcomeBucket(weightedScore, redFlagCount);
    final double t = _markerPositionForBar(weightedScore, bucket);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 28,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.shade200,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment(t * 2 - 1, 0),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: themecolor, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool useNewLogic = widget.responses.length >= 10;
    int weightedScore;
    int redFlagCount;
    int bucket;
    if (useNewLogic) {
      weightedScore = _getWeightedScore(widget.responses);
      redFlagCount = _getRedFlagCount(widget.responses);
      bucket = _outcomeBucket(weightedScore, redFlagCount);
    } else {
      int oldScore = 0;
      int oldSeriousCount = 0;
      for (String r in widget.responses) {
        int p = _optionToPoints(r);
        oldScore += p;
        if (p >= 3) oldSeriousCount++;
      }
      if (oldSeriousCount >= 2 || oldScore >= 15) {
        bucket = 2;
        weightedScore = 50;
        redFlagCount = 2;
      } else if (oldSeriousCount >= 1 || oldScore >= 7) {
        bucket = 1;
        weightedScore = 28;
        redFlagCount = 0;
      } else {
        bucket = 0;
        weightedScore = 8;
        redFlagCount = 0;
      }
    }

    String titleText;
    String adviceText;
    bool showChatbotButton;
    String resultLabel;

    if (bucket == 2) {
      resultLabel = "Some of your experiences strongly relate to bullying";
    } else if (bucket == 1) {
      resultLabel = "Some of your experiences may relate to bullying";
    } else {
      resultLabel = "Things look okay";
    }

    titleText = resultLabel;
    adviceText =
        "This result is based on your questionnaire responses. If you want support, you can talk to Ray or reach out to a trusted adult.";
    showChatbotButton = true;

    return Scaffold(
      backgroundColor: lightThemeColor,
      appBar: AppBar(
        backgroundColor: themecolor,
        title: Text("Results", style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              const SizedBox(height: 12),
              _resultBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your result",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: themecolor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resultLabel,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSeverityBar(weightedScore, redFlagCount),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _resultBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What this means",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: themecolor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      titleText,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      adviceText,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _resultBox(
                child: Column(
                  children: [
                    Image.asset("assets/ray.png", width: 120),
                    const SizedBox(height: 12),
                    Text(
                      "I'm here if you want to talk.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _resultBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Next steps",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: themecolor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (showChatbotButton) ...[
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(task: "", text: ""),
                            ),
                          );
                        },
                        icon: Icon(Icons.chat_bubble_outline, color: themecolor, size: 22),
                        label: Text(
                          "Talk to Ray",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: themecolor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: themecolor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themecolor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 2,
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "This is a self-check tool for awareness, not a medical diagnosis.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: child,
    );
  }
}

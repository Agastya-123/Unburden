import 'package:flutter/material.dart';

import '../colors.dart';

class EmotionalMentalHealthEffects extends StatefulWidget {
  @override
  State createState() => _EmotionalMentalHealthEffectsState();
}

class _EmotionalMentalHealthEffectsState extends State<EmotionalMentalHealthEffects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themecolor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Emotional and Mental Health Effects of Bullying",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Bullying can affect much more than a student's daily experiences at school. When someone is repeatedly targeted, the emotional impact can be significant and long-lasting. Students who experience bullying often report feelings of sadness, anxiety, fear, or loneliness.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Being bullied can make students feel unsafe in places where they should feel comfortable, such as school or social environments. Over time, this stress can affect how a person thinks about themselves and how they interact with others. A student who is repeatedly mocked or excluded may begin to doubt their own abilities or feel that they do not belong.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "For example, a student who is constantly teased about their appearance might start avoiding group activities or speaking less in class because they fear being laughed at again. These experiences can gradually reduce confidence and increase feelings of isolation.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "In some cases, prolonged bullying can contribute to anxiety, depression, and emotional distress. Students may struggle to concentrate in school, experience difficulty sleeping, or feel overwhelmed by negative thoughts.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Recognizing these emotional effects is important because it highlights why bullying should never be ignored. When students receive support from teachers, parents, and friends, it becomes easier to address the problem and protect their mental well-being.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Creating supportive environments where students feel heard and respected can help reduce the psychological harm caused by bullying.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: lightThemeColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: themecolor.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Key Idea",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: themecolor),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Bullying can have serious emotional effects, including anxiety, sadness, low self-esteem, and feelings of isolation.",
                      style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Adapted from research and educational resources provided by: American Psychological Association; StopBullying.gov; Centers for Disease Control and Prevention Youth Violence Prevention resources; UNESCO reports on school bullying and violence.",
                style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

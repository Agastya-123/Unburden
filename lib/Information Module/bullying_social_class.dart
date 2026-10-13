import 'package:flutter/material.dart';

import '../colors.dart';

class BullyingSocialClass extends StatefulWidget {
  @override
  State createState() => _BullyingSocialClassState();
}

class _BullyingSocialClassState extends State<BullyingSocialClass> {
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
                "Bullying and Social Class Differences",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Students often notice differences among their classmates. These differences may involve clothing, gadgets, transportation, hobbies, or the kinds of activities families can afford. While diversity in background is a normal part of society, these differences can sometimes become reasons for teasing or bullying.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Children from lower economic backgrounds may sometimes be targeted because they cannot afford certain items that others consider fashionable or popular. For example, a student might be teased for wearing older clothes, using a simple phone, or not being able to join expensive school trips or activities. These comments can make the student feel embarrassed or excluded.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "At the same time, students from wealthier families can also experience bullying. Classmates may stereotype them as arrogant, spoiled, or privileged, even if those assumptions are not true. In these situations, resentment or jealousy may lead to social exclusion or hostile behavior.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "These examples show how differences in economic or social background can influence peer relationships. When students judge others based on material possessions or family circumstances, it can create divisions within social groups.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Schools and communities can reduce these problems by encouraging students to value kindness, respect, and character rather than material possessions. Promoting empathy and understanding helps create environments where students appreciate diversity instead of using it as a reason to exclude others.",
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
                      "Differences in economic or social background should not define how students treat each other. Respect and empathy help prevent bullying based on these differences.",
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

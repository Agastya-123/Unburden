import 'package:flutter/material.dart';

import '../colors.dart';

class HowToHelpFriend extends StatefulWidget {
  @override
  State createState() => _HowToHelpFriendState();
}

class _HowToHelpFriendState extends State<HowToHelpFriend> {
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
                "How to Help a Friend Who Is Being Bullied",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Seeing a friend or classmate being bullied can be difficult. Many students feel unsure about what they should do or worry that getting involved might make the situation worse. However, supportive peers can play an important role in helping someone who is experiencing bullying.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "One of the most helpful things a student can do is listen and show support. A friend who is being bullied may feel embarrassed or afraid to talk about their experiences. Simply letting them know that they are not alone and that someone cares can make a significant difference.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Encouraging the friend to talk to a trusted adult is another important step. Teachers, school counselors, parents, or other responsible adults can help address the situation and ensure that the student receives the support they need. Sometimes students feel more comfortable reporting the problem when a friend helps them do it.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Students can also help by including the person who is being targeted in activities and refusing to participate in teasing or rumors. When classmates choose kindness and inclusion, it reduces the social reward that sometimes encourages bullying behavior.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "For example, if a student is being excluded from group activities, inviting them to join a conversation or sit with friends during lunch can help them feel supported and less isolated.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Helping a friend does not mean confronting the bully directly or putting oneself in danger. Instead, it means showing empathy, offering support, and helping ensure that responsible adults are aware of the situation.",
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
                      "Supporting a friend who is being bullied can include listening, showing kindness, encouraging them to seek help, and refusing to participate in harmful behavior.",
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

import 'package:flutter/material.dart';

import '../colors.dart';

class AcademicSocialConsequences extends StatefulWidget {
  @override
  State createState() => _AcademicSocialConsequencesState();
}

class _AcademicSocialConsequencesState extends State<AcademicSocialConsequences> {
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
                "Academic and Social Consequences of Bullying",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Bullying can affect more than just a student's emotions. When students experience repeated harassment or exclusion, it can also influence their academic performance and social life. Feeling unsafe or uncomfortable at school can make it difficult to focus on learning and participating in activities.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Students who are being bullied may begin to avoid situations where the bullying occurs. For example, a student might skip classes, avoid certain areas of the school, or stop participating in clubs and sports because they fear encountering the person who is bullying them. Over time, this avoidance can lead to missed learning opportunities and lower academic performance.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Bullying can also affect friendships and social relationships. A student who feels repeatedly targeted may become withdrawn or hesitant to interact with others. They may worry that classmates will judge them or join in the bullying behavior. This can create feelings of isolation and loneliness.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "For instance, a student who is mocked during group work might stop volunteering answers in class or participating in discussions. Even if they understand the material, fear of embarrassment can prevent them from engaging fully in school activities.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "These academic and social consequences show why bullying is not only a personal problem but also an educational one. When students feel safe and supported, they are more likely to participate confidently in school and build positive relationships with their peers.",
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
                      "Bullying can affect both school performance and social relationships, making students feel unsafe, isolated, or hesitant to participate in activities.",
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

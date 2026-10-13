import 'package:flutter/material.dart';

import '../colors.dart';

class HowTo extends StatefulWidget {
  @override
  State createState() => _HowToState();
}

class _HowToState extends State<HowTo> {
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
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Image.asset("assets/info/to_do.png"),
              ),
              SizedBox(height: 24),
              Text(
                "What To Do If You Are Being Bullied",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Experiencing bullying can be confusing and upsetting. Students who are being bullied may feel embarrassed, afraid, or unsure about how to respond. It is important to remember that bullying is never the victim's fault, and no one deserves to be treated with cruelty or disrespect.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "One of the most important steps a student can take is to tell a trusted adult. This might include a parent, teacher, school counselor, or another adult who can help address the situation. Many students hesitate to report bullying because they fear it may make the situation worse, but adults are often able to intervene and provide support.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Staying connected with supportive friends can also make a difference. Friends can provide emotional encouragement, include the student in activities, and sometimes help report the situation if the victim feels uncomfortable doing so alone.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "In cases of cyberbullying, it is helpful to keep evidence of the behavior. Saving screenshots or messages can make it easier for adults or school administrators to understand what is happening and take appropriate action.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Students experiencing bullying should also try to avoid responding with aggression. Although anger is a natural reaction, responding aggressively can sometimes escalate the situation and create further conflict.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Seeking help is a positive and responsible step. When students speak up about bullying, they help create safer environments where harmful behavior can be addressed and prevented.",
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
                      "If you are being bullied, remember that it is not your fault, and speaking to a trusted adult is one of the most effective ways to get help.",
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

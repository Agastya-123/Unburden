import 'package:flutter/material.dart';

import '../colors.dart';

class RoleOfBystanders extends StatefulWidget {
  @override
  State createState() => _RoleOfBystandersState();
}

class _RoleOfBystandersState extends State<RoleOfBystanders> {
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
                "The Role of Bystanders",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Bullying often does not happen in complete isolation. In many situations, other students are present and witness the behavior. These individuals are known as bystanders. The way bystanders react can play an important role in whether bullying continues or stops.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Sometimes bystanders unintentionally encourage bullying. When students laugh at hurtful jokes, share rumors, or remain silent, the person bullying may feel supported. This attention can act as a reward, making the behavior more likely to continue.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "In other cases, students may stay silent because they feel unsure about what to do. They might worry about becoming the next target or believe that the situation is not their responsibility. These feelings are common, especially when bullying occurs within larger groups.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "However, bystanders can also have a positive influence. Research shows that bullying often stops more quickly when peers show support for the person being targeted. Simple actions, such as refusing to laugh at harmful jokes, including someone who has been excluded, or reporting the situation to a trusted adult, can make a significant difference.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "For example, if a group of students refuses to participate in teasing and instead invites the targeted student to join their activity, the social reward for bullying disappears. When peers show empathy and support, it becomes harder for bullying behavior to continue.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Teaching students how to respond safely as bystanders helps create school environments where kindness and respect are encouraged.",
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
                      "Bystanders can influence bullying situations. When students show support for the victim and refuse to encourage harmful behavior, bullying is more likely to stop.",
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

import 'package:flutter/material.dart';

import '../colors.dart';

class BullyingSocialStatus extends StatefulWidget {
  @override
  State createState() => _BullyingSocialStatusState();
}

class _BullyingSocialStatusState extends State<BullyingSocialStatus> {
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
                "Bullying and Social Status",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "In many schools, informal social groups naturally develop. Some students become more popular or influential, while others may feel less socially connected. These differences in social status can sometimes play a role in bullying behavior.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "For some individuals, bullying becomes a way to gain attention or maintain influence within a group. By humiliating, teasing, or excluding someone, a student may attempt to demonstrate power or reinforce their position in the social hierarchy. When other students laugh or support the behavior, the bully may feel encouraged to continue.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "For example, a student who wants to appear confident or popular might start making jokes about another classmate in front of others. If the group laughs, the behavior may become repeated because the bully receives social approval or recognition.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Interestingly, research shows that bullies are not always socially isolated. In some cases, students with higher social influence may use relational bullying, such as spreading rumors or controlling group friendships, as a strategy to maintain their status.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "This does not mean that popularity automatically leads to bullying, but it shows how group dynamics can influence behavior. When social approval is linked to teasing or exclusion, some students may feel pressure to participate even if they know it is wrong.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Creating school environments that value respect, empathy, and inclusion helps reduce the social rewards that sometimes encourage bullying behavior.",
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
                      "Bullying can sometimes be used as a way to gain or maintain social status and influence within peer groups.",
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

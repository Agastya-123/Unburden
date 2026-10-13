import 'package:flutter/material.dart';

import '../colors.dart';

class HowSchoolsPrevent extends StatefulWidget {
  @override
  State createState() => _HowSchoolsPreventState();
}

class _HowSchoolsPreventState extends State<HowSchoolsPrevent> {
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
                "How Schools and Communities Prevent Bullying",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Preventing bullying requires more than just responding to individual incidents. Schools, families, and communities all play important roles in creating environments where students feel safe, respected, and supported.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Schools can reduce bullying by establishing clear rules and expectations for respectful behavior. When students understand that harmful actions such as teasing, exclusion, or harassment will not be tolerated, they are more likely to treat others with consideration. Teachers and school staff also help by supervising shared spaces, responding quickly to reports of bullying, and encouraging open conversations about kindness and respect.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Educational programs that teach empathy, communication skills, and conflict resolution can also make a significant difference. When students learn how to express their feelings, manage disagreements, and understand others' perspectives, they are better equipped to build positive relationships.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Parents and families also contribute to prevention by discussing respectful behavior at home and encouraging children to speak openly about their experiences at school. When students know they can talk to trusted adults, they are more likely to report bullying before it becomes a serious problem.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Communities can further support prevention by promoting awareness campaigns, providing resources for schools, and encouraging collaboration between educators, families, and mental health professionals.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "When schools and communities work together to promote respect and inclusion, bullying becomes less likely to occur. Creating safe and supportive environments allows students to focus on learning, building friendships, and developing confidence.",
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
                      "Bullying prevention is most effective when schools, families, and communities work together to promote respect, empathy, and safe environments for students.",
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

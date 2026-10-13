import 'package:flutter/material.dart';

import '../colors.dart';

class SourcesReferences extends StatefulWidget {
  @override
  State createState() => _SourcesReferencesState();
}

class _SourcesReferencesState extends State<SourcesReferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themecolor,
        title: Text(
          "Sources and References",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                "The information in this module is adapted from research and educational resources on bullying, adolescent psychology, and youth development. These sources are widely used by educators, psychologists, and public health organizations to understand and prevent bullying among children and adolescents.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 24),
              Text(
                "Key Educational Resources",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: themecolor),
              ),
              SizedBox(height: 12),
              _BulletItem(
                  "American Psychological Association – Research articles and educational resources on bullying behavior, social dynamics, and adolescent mental health."),
              _BulletItem(
                  "StopBullying.gov – A national resource providing research-based guidance on identifying, preventing, and responding to bullying."),
              _BulletItem(
                  "Centers for Disease Control and Prevention Youth Violence Prevention – Research on the psychological and social effects of bullying and strategies for prevention."),
              _BulletItem(
                  "UNESCO – Global reports on school violence and bullying among children and adolescents."),
              _BulletItem(
                  "National Institutes of Health – Research studies on child development, mental health, and the impact of bullying on wellbeing."),
              SizedBox(height: 24),
              Text(
                "Academic Research",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: themecolor),
              ),
              SizedBox(height: 12),
              Text(
                "The content in this module also reflects findings from peer-reviewed research on bullying, including studies on:",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 8),
              _BulletItem("psychological causes of bullying"),
              _BulletItem("power imbalance in peer relationships"),
              _BulletItem("social dynamics and bystander behavior"),
              _BulletItem("emotional and academic effects of bullying"),
              SizedBox(height: 10),
              Text(
                "These studies are published in journals such as Journal of School Psychology, Child Development, and Journal of Adolescent Health.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 24),
              Text(
                "Purpose of This Module",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: themecolor),
              ),
              SizedBox(height: 12),
              Text(
                "This information module is designed to help students:",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 8),
              _BulletItem("understand what bullying is"),
              _BulletItem("recognize different forms of bullying"),
              _BulletItem("learn how bullying affects mental health and relationships"),
              _BulletItem("discover ways to seek help and support others"),
              SizedBox(height: 12),
              Text(
                "The goal is to promote awareness, empathy, and safer social environments for young people.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: lightThemeColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: themecolor.withOpacity(0.5)),
                ),
                child: Text(
                  "This educational content is adapted from publicly available research and resources on bullying and youth wellbeing.",
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(fontSize: 15, height: 1.4, color: themecolor),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

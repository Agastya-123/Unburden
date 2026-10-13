import 'package:flutter/material.dart';

import '../colors.dart';

class PowerImbalance extends StatefulWidget {
  @override
  State createState() => _PowerImbalanceState();
}

class _PowerImbalanceState extends State<PowerImbalance> {
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
                "Power Imbalance in Bullying",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "One of the key characteristics that separates bullying from ordinary disagreements is the presence of a power imbalance. This means that the person bullying has some type of advantage that makes it difficult for the other person to defend themselves or stop the behavior.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Power does not always come from physical strength. In many cases, power can come from popularity, social influence, age, confidence, or group support. A student who has many friends or holds a higher social position in a group may be able to influence others more easily than someone who is quieter or less socially connected.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "For example, imagine a popular student who begins spreading rumors about a quieter classmate. Because many students trust or follow the popular individual, the rumors may spread quickly and the targeted student may struggle to defend themselves. Even if the victim speaks up, others may hesitate to support them because they fear losing their own social standing.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Power imbalance can also appear when several students target one individual. Even if each person contributes only small actions—such as laughing, teasing, or excluding someone—the combined effect can make the victim feel overwhelmed and isolated.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "This imbalance of power is one of the reasons bullying can be so damaging. When someone feels outnumbered or socially disadvantaged, they may believe there is no safe way to stop the behavior.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Recognizing power imbalances helps teachers, parents, and students understand why bullying often requires support from others to be addressed effectively.",
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
                      "Bullying often involves a power imbalance, where one person has more influence, support, or authority than the person being targeted.",
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

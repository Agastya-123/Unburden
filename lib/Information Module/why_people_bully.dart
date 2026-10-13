import 'package:flutter/material.dart';

import '../colors.dart';

class WhyPeopleBully extends StatefulWidget {
  @override
  State createState() => _WhyPeopleBullyState();
}

class _WhyPeopleBullyState extends State<WhyPeopleBully> {
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
                "Why Do People Bully?",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "When people hear about bullying, they often assume that bullies behave aggressively simply because they enjoy hurting others. In reality, bullying behavior is usually influenced by a combination of psychological, social, and environmental factors. Understanding these causes helps explain why bullying occurs and how it can be prevented.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "One reason some individuals bully others is the desire for power or social status. In school environments where popularity and influence matter, some students may attempt to gain attention or strengthen their position within a group by intimidating others. When peers laugh or support the behavior, the bully may feel rewarded and continue the actions.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Bullying can also be influenced by a person's environment and experiences. Children who grow up observing aggressive behavior at home or who experience harsh discipline may learn to use aggression as a way to solve problems. In these situations, bullying may be a learned behavior rather than a conscious attempt to harm others.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Emotional difficulties may also contribute to bullying behavior. Some individuals struggle with poor emotional regulation, insecurity, or frustration. A student who feels powerless or angry in certain areas of life may attempt to regain control by targeting someone who appears more vulnerable.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Peer pressure can play an important role as well. In some social groups, teasing or excluding others may become normalized. Students may participate in bullying to gain acceptance from friends or to avoid becoming targets themselves.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Understanding why people bully does not excuse harmful behavior, but it highlights the importance of teaching empathy, emotional awareness, and respectful communication. When students learn healthier ways to deal with frustration and social challenges, bullying becomes less likely to occur.",
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
                      "Bullying often develops from a combination of social pressure, desire for power, emotional difficulties, and environmental influences, rather than a single cause.",
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

import 'package:flutter/material.dart';

import '../colors.dart';

class TeasingConflictBullying extends StatefulWidget {
  @override
  State createState() => _TeasingConflictBullyingState();
}

class _TeasingConflictBullyingState extends State<TeasingConflictBullying> {
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
                "Teasing, Conflict, and Bullying: Understanding the Difference",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                "Students sometimes disagree with each other, joke with friends, or tease one another. These situations are a normal part of social interactions, especially as children and teenagers learn how to communicate and build relationships. However, it is important to understand when these behaviors cross the line and become bullying.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Conflict happens when two people disagree or argue but have relatively equal power in the situation. Both individuals may say things they regret, but neither person is trying to dominate or repeatedly harm the other. Conflicts are usually temporary and can often be resolved through discussion, compromise, or adult guidance.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Teasing can also occur among friends in a playful way. When teasing is mutual and both people are comfortable, it may simply be part of friendly interaction. For example, friends might jokingly tease each other about a sports team or a funny mistake. In healthy teasing, the behavior stops if someone becomes upset.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Bullying is different because it involves intentional harm and repetition. The person bullying often targets the same individual again and again, and the victim may feel unable to defend themselves. Bullying also usually involves a power imbalance, where one person has more social influence, physical strength, or support from others.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "For instance, if two classmates argue over a group project and later resolve the disagreement, that situation is conflict. But if one student repeatedly insults another student in front of others and encourages classmates to laugh or exclude them, the situation becomes bullying.",
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              SizedBox(height: 14),
              Text(
                "Understanding these differences helps students recognize when a situation requires help from teachers, parents, or trusted adults.",
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
                      "Conflicts and teasing may happen occasionally, but bullying involves repeated harm and a power imbalance that makes it difficult for the victim to stop the behavior.",
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

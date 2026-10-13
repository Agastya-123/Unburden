import '/Information%20Module/how_prevent.dart';
import '/Information%20Module/how_to.dart';
import '/Information%20Module/how_to_help_friend.dart';
import '/Information%20Module/how_schools_prevent.dart';
import '/Information%20Module/info_article.dart';
import '/Information%20Module/sources_references.dart';
import '/Information%20Module/bullying_social_class.dart';
import '/Information%20Module/academic_social_consequences.dart';
import '/Information%20Module/emotional_mental_health_effects.dart';
import '/Information%20Module/bullying_social_status.dart';
import '/Information%20Module/power_imbalance.dart';
import '/Information%20Module/role_of_bystanders.dart';
import '/Information%20Module/signs.dart';
import '/Information%20Module/teasing_conflict_bullying.dart';
import '/Information%20Module/types.dart';
import '/Information%20Module/what_is.dart';
import '/Information%20Module/why_people_bully.dart';
import '/Information%20Module/why_step_in.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class InfoScreen extends StatefulWidget {
  @override
  State createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: themecolor,
          title: Text("Information Module", style: TextStyle(fontWeight: FontWeight.w700),),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24,),
                _SectionHeader(title: "Understanding Bullying"),
                SizedBox(height: 12,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Card(title: "What Is Bullying", screen: WhatIs()),
                      SizedBox(width: 20,),
                      _Card(title: "Types of Bullying", screen: Types()),
                      SizedBox(width: 20,),
                      _Card(title: "Teasing vs Conflict vs Bullying", screen: TeasingConflictBullying()),
                      SizedBox(width: 20,),
                      _Card(title: "Why People Bully", screen: WhyPeopleBully()),
                    ],
                  ),
                ),
                SizedBox(height: 28,),
                _SectionHeader(title: "Social Dynamics"),
                SizedBox(height: 12,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Card(title: "Power Imbalance in Bullying", screen: PowerImbalance()),
                      SizedBox(width: 20,),
                      _Card(title: "Bullying and Social Status", screen: BullyingSocialStatus()),
                      SizedBox(width: 20,),
                      _Card(title: "Bullying and Social Class Differences", screen: BullyingSocialClass()),
                      SizedBox(width: 20,),
                      _Card(title: "The Role of Bystanders", screen: RoleOfBystanders()),
                    ],
                  ),
                ),
                SizedBox(height: 28,),
                _SectionHeader(title: "Psychological Effects"),
                SizedBox(height: 12,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Card(title: "Emotional and Mental Health Effects", screen: EmotionalMentalHealthEffects()),
                      SizedBox(width: 20,),
                      _Card(title: "Academic and Social Consequences", screen: AcademicSocialConsequences()),
                      SizedBox(width: 20,),
                      _Card(title: "Why Victims Often Stay Silent", screen: InfoArticleScreen(title: "Why Victims Often Stay Silent")),
                    ],
                  ),
                ),
                SizedBox(height: 28,),
                _SectionHeader(title: "Prevention"),
                SizedBox(height: 12,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Card(title: "What To Do If You Are Being Bullied", screen: HowTo()),
                      SizedBox(width: 20,),
                      _Card(title: "How to Help a Friend Who Is Being Bullied", screen: HowToHelpFriend()),
                      SizedBox(width: 20,),
                      _Card(title: "How Schools and Communities Prevent Bullying", screen: HowSchoolsPrevent()),
                    ],
                  ),
                ),
                SizedBox(height: 24,),
                Divider(color: themecolor,),
                SizedBox(height: 20,),
                _SectionHeader(title: "Parent Hub"),
                Text("A central place for everything you need to support your child through bullying.",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Card(title: "What signs to look for?", screen: Signs()),
                      SizedBox(width: 20,),
                      _Card(title: "How to Help Prevent Bullying?", screen: HowPrevent()),
                      SizedBox(width: 20,),
                      _Card(title: "Why should I step in?", screen: WhyStepIn()),
                    ],
                  ),
                ),
                SizedBox(height: 28,),
                _SectionHeader(title: "Learn More"),
                SizedBox(height: 12,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Card(title: "Sources and References", screen: SourcesReferences()),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                SizedBox(height: 24,),
              ],
            ),
          ),
        ),
      );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
      textAlign: TextAlign.left,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({Key? key, required this.title, required this.screen}) : super(key: key);
  final String title;
  final dynamic screen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 180,
          height: 88,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: themecolor.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 14, color: themecolor),
            ],
          ),
        ),
      ),
    );
  }
}

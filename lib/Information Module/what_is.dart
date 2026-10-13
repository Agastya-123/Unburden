import 'package:flutter/material.dart';

import '../colors.dart';

class WhatIs extends StatefulWidget {
  @override
  State createState() => _WhatIsState();
}

class _WhatIsState extends State<WhatIs> {
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
                SizedBox(height: 20,),
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Image.asset("assets/info/is_it.png", )
                ),
                SizedBox(height: 40,),
                Text("What Is Bullying?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20), textAlign: TextAlign.center),
                SizedBox(height: 20,),
                Text("Sometimes students argue with each other or say things they later regret. Disagreements and occasional teasing can happen in friendships or classrooms. These situations may feel uncomfortable, but they are not always bullying.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("Bullying is different. It occurs when someone intentionally harms, embarrasses, or intimidates another person and continues doing so repeatedly over time. In many cases, the person being targeted feels unable to stop the situation because the person bullying them has more power or influence.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("Psychologists often describe bullying using three important characteristics. First, the behavior is intentional, meaning the person is trying to cause harm or distress. Second, it is repeated, occurring multiple times rather than as a single event. Third, there is usually a power imbalance, where the person bullying may be physically stronger, socially more popular, older, or supported by a group.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("For example, imagine a student who is constantly mocked by classmates because of their appearance or the way they speak. At first, the comments may seem like jokes, but if they continue every day and others begin to join in or laugh, the situation becomes bullying. The repeated humiliation can make the student feel isolated and unsafe at school.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("Bullying does not always involve physical actions. It can also happen through words, social exclusion, rumors, or harmful messages shared online. Even when no physical harm occurs, the emotional impact can be serious and long-lasting.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("Understanding what bullying is helps students recognize harmful behavior and seek help when needed. Identifying bullying early allows teachers, parents, and communities to intervene and create environments where everyone feels respected and safe.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 20,),
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
                      Text("Key Idea", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: themecolor)),
                      SizedBox(height: 6),
                      Text("Bullying involves intentional harm, repeated behavior, and a power imbalance between individuals.", style: TextStyle(fontSize: 15, height: 1.4, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text("Adapted from research and educational resources provided by: American Psychological Association; StopBullying.gov; Centers for Disease Control and Prevention Youth Violence Prevention resources; UNESCO reports on school bullying and violence.", style: TextStyle(fontSize: 12, height: 1.3, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                SizedBox(height: 24,),
                 ],
            ),
          ),
        )
    );
  }

}
import 'package:flutter/material.dart';

import '../colors.dart';

class HowPrevent extends StatefulWidget {
  @override
  State createState() => _HowPreventState();
}

class _HowPreventState extends State<HowPrevent> {
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
              Text("How to Help Prevent Bullying?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              SizedBox(height: 20,),
              Text("The first step in protecting your child—whether in person or online—is helping them understand what bullying is.", style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              Text("1. Teach Them About Bullying", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.left,),
              SizedBox(height: 10,),
              Text("When kids know what bullying looks like, they can recognize it—whether it happens to them or someone else.", style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              Text("2. Keep the Conversation Going", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.left,),
              SizedBox(height: 10,),
              Text("Talk regularly with your child about school, friends, and online activity. Open, ongoing conversations help them feel safe sharing any concerns", style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              Text("3. Encourage Positive Behavior", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.left,),
              SizedBox(height: 10,),
              Text("Even if they’re not directly involved, kids can make a difference by being kind, including others, and speaking up when they see bullying.", style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              Text("4. Build Their Confidence", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.left,),
              SizedBox(height: 10,),
              Text("Support your child in joining activities they enjoy. Being involved helps boost self-esteem and creates connections with like-minded peers.", style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              Text("5. Lead by Example", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.left,),
              SizedBox(height: 10,),
              Text("Model respect and kindness in your own actions. How you treat others—in person and online—teaches your child how to do the same.", style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              Text("6. Stay Involved Online", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.left,),
              SizedBox(height: 10,),
              Text("Know the apps and sites your child uses. Talk to them about staying safe online and remind them the digital world affects real life too.", style: TextStyle(fontSize: 15),)
            ],
          ),
        ),
      )
    );
  }
  
}
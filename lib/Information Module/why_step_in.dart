import 'package:flutter/material.dart';

import '../colors.dart';

class WhyStepIn extends StatefulWidget {
  @override
  State createState() => _WhyStepInState();
}

class _WhyStepInState extends State<WhyStepIn> {
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
                Text("Why You Should Step In if Your Child Is Being Bullied?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18), ),
                SizedBox(height: 20,),
                Text("Bullying can deeply affect a child’s well-being, both physically and emotionally. Beyond the risk of physical harm, it can lead to mental health challenges like anxiety, depression, lower academic performance, and even substance use.", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("Cyberbullying adds another layer of harm—it can happen anytime, anywhere, and spreads quickly to a wide audience. The digital footprint it leaves can be lasting and difficult to erase.", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("aEvery child deserves a safe, respectful learning environment where they feel valued. They have a right to be protected from any form of harm—bullying included. Intervening early helps protect that right and supports their long-term health and success.", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
               ],
            ),
          ),
        )
    );
  }

}
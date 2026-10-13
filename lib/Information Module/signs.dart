import 'package:flutter/material.dart';

import '../colors.dart';

class Signs extends StatefulWidget {
  @override
  State createState() => _SignsState();
}

class _SignsState extends State<Signs> {
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
                Text("I’m not sure if my child is being bullied. What signs should I look out for?", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                SizedBox(height: 20,),
                Text("Keep an eye on your child's emotional state, as some children may not express their concerns verbally. \nSigns to look out for include:", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Physical marks such as unexplained bruises, scratches, broken bones and healing wounds ", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Fear of going to school or joining school events", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Being anxious, nervous or very vigilant", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Having few friends in school or outside of school", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Losing friends suddenly or avoiding social situations", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Clothing, electronics or other personal belongings being lost or destroyed", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Often asking for money", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Low academic performance", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Absenteeism, or calling from school asking to go home", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Trying to stay near adults", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Not sleeping well and may be having nightmares", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Complaining of headaches, stomach aches or other physical ailments", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Regularly distressed after spending time online or on their phone (without a reasonable explanation)", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Becomes unusually secretive, especially when it comes to online activities", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
                Text("🔸Being aggressive or having angry outbursts", style: TextStyle(fontSize: 15),),
                SizedBox(height: 10,),
              ],
            ),
          ),
        )
    );
  }

}
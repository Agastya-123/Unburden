
import '/Home/Meditation/meditation%20screen.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';


class MInstructions extends StatefulWidget{

  MInstructions({Key? key, required this.audio_name}) : super(key: key);
  final String audio_name;

  @override
  State<StatefulWidget> createState() {
    return _MInstructionsState();
  }
}

class _MInstructionsState extends State<MInstructions> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: themecolor,
          title: Text("Meditation Instructions",style: TextStyle(fontWeight: FontWeight.w700) ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text("Find a Quiet Space",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18,),),
                SizedBox(height: 10,),
                Text("Choose a comfortable and quiet spot where you won't be disturbed. Sit in a relaxed position with your back straight.",
                    style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                Image.asset("assets/m_antibully.gif", height: 200,width: 200,),
                SizedBox(height: 20,),
                Text("Focus on Your Breathing",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18,),),
                SizedBox(height: 10,),
                Text("Close your eyes and take deep breaths in and out. Pay attention to the sensation of air entering and leaving your body.",
                    style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                SizedBox(height: 30,),
                Text("Clear Your Mind",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                SizedBox(height: 10,),
                Text("Let go of distracting thoughts. If your mind wanders, gently bring your focus back to your breath.",
                    style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context,
                      MaterialPageRoute(builder:(context)=> Meditation(audio_name: widget.audio_name,)),
                    );
                  },
                  child: Text("Lets meditate",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700, color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themecolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    minimumSize: const Size(170, 30),
                    elevation: 5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

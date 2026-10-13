import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';
import 'meditation options.dart';
class MSplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MSplashScreenState();
  }
}

class _MSplashScreenState extends State<MSplashScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height - 150,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/Ray-M.png",width: 150,height: 150,),
                SizedBox(height: 20,),
                Text("Meditation helps you feel calm and relaxed. \n"
                    "It makes your mind clear, helps you focus better, and can make you feel happier. \n"
                    "It’s like a little break for your brain to feel good and refreshed!",
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,), textAlign: TextAlign.center,),
                ]
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MOptions()));
                    },
                    child: Text("Next",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themecolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      minimumSize: const Size(120, 30),
                      elevation: 5,
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
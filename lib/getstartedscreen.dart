import "/BottomNav.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "colors.dart";
class GetStartedScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _GetStartedScreenState();
  }
}
class _GetStartedScreenState extends State<GetStartedScreen>{
  TextEditingController nicknameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hey,",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w900),),
                  SizedBox(width: 10,),
                  Image.asset("assets/panda_welcome.png",width: 70,),
                  SizedBox(width: 10,),
                  Text("I'm Ray",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w900),),
                ],
              ),
              SizedBox(height: 50,),
              Text("No pressure."
                  "\nNo rush here - you control what to share and when!"
                  "\nOur chats stay private,  just between you and me. When you're ready to unlock all the cool features with me, you can share a bit more info."
                  "\n\nNow pick a fun and positive nickname, and we’re good to go!", textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
              SizedBox(height: 100,),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    padding: EdgeInsets.only(left: 50, right: 20, ),
                    decoration: BoxDecoration(
                      border:Border.all(width:3, color: themecolor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: nicknameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      child: Image.asset("assets/panda_input.png",width: 90,),
                      top: -48,
                      left: -10,
                  ),
                ],
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('username', nicknameController.text);
                  final nickname = prefs.getString('username') ?? 0;
                  print("Nickname $nickname");

                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:(context)=>HomePageScreen())
                  );
                },
                child: Icon(Icons.arrow_forward, color: Colors.black,),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themecolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minimumSize: const Size(100, 40),
                  elevation: 5,
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

}
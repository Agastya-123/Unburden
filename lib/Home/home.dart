import "/ChatBot/chatbot.dart";
import "/Home/Games/coloring/coloring_options.dart";
import "/Home/Games/puzzle/puzzle_options.dart";
import "/Home/slot_machine.dart";
import "/Home/sos.dart";
import "/Profile/Profile.dart";
import "/colors.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

import "../Authentication/login_email.dart";
import "Games/coloring/colorBook.dart";
import "Games/flipcardgame.dart";
// import "Games/maze.dart";
import "Games/puzzle/jigsaw_puzzle.dart";
import "Meditation/meditation splashscreen.dart";
import "Questionnaire/Questionnaire.dart";
import "talk_to_chair.dart";

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unburden",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700,),),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder:(context)=>SOSScreen())
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 7),
              minimumSize: const Size(50, 30),
              elevation: 5,
            ),
            child: Text("SOS", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),),
          ),
          IconButton(
              onPressed: (){
                Navigator.push(context,
                        MaterialPageRoute(builder:(context)=>Profile()));
              },
              icon: Icon(FontAwesomeIcons.solidUser, color: themecolor,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: lightThemeColor,
                  boxShadow: [
                    BoxShadow(
                        color: darkThemeColor,
                      offset: Offset(
                        4.0,
                        4.0,
                      ),
                    )
                 ]
                ),
                child: Row(
                  children: [
                    Image.asset("assets/ray.png",width: 120,height: 150,),
                    Flexible(
                      child: Column(
                        children: [
                          Text("Meet Ray, Your AI Companion!",
                            style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 7,),
                          Text("Feeling down or just need to talk? Ray’s here to listen and help whenever you need.",
                              style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),
                          ElevatedButton(
                            onPressed: (){
                              User? user = FirebaseAuth.instance.currentUser;
                              if(user == null){
                                LoginAlertDialog(context);
                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(task: 'chat', text: "")));
                              }
                            },
                            child: Text("Connect",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
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
                          SizedBox(height: 10,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Divider(color: themecolor,),
              // SizedBox(height: 10,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  // color: Colors.blue,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("Daily Challenge "
                              "\nJackpot",
                            style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15,),
                          ElevatedButton(
                            onPressed: (){
                              User? user = FirebaseAuth.instance.currentUser;
                              if(user == null){
                                LoginAlertDialog(context);
                              }
                              else {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => SlotMachine()));
                              }
                            },
                            child: Text("Play",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
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
                        ],
                      ),
                      SizedBox(width: 40,),
                      Image.asset("assets/bingo.png",height: 170,width: 170,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Divider(color: themecolor,),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/1.8,
                      child: Column(
                        children: [
                          Text("Are You Being Bullied?",
                            style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 7,),
                          Text("Take this quiz to understand what's happening, recognize the signs and learn how to take control",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder:(context)=>Questions()));
                      },
                      child: Image.asset("assets/arrow.png", width: 60, height: 30,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themecolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        minimumSize: const Size(120, 30),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Divider(color: themecolor,),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/1.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Talk to the Chair",
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 7,),
                          Text(
                            "Vent out your feelings. Nothing gets recorded. Speak freely.",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TalkToChairScreen()),
                        );
                      },
                      child: Text("Start", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themecolor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        minimumSize: const Size(100, 36),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Divider(color: themecolor,),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                child :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 230,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Self-Care Hub",
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Take a moment to breathe, relax, and find your calm through meditation.",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),

                          _Card(title: "Calm Down Space", image: "9"),
                  ]
                ),
              ),
              SizedBox(height: 20,),
              Divider(color: themecolor,),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerLeft,
                child :
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Play & Unwind",
                        style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                      Text("Enjoy simple games to relax, recharge, and lift your mood.",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _Card(title: "Puzzle", image: "puzzle"),
                            SizedBox(width: 20,),
                            _Card(title: "Memory Flip", image: "memory_flip"),
                            SizedBox(width: 20,),
                            // _Card(title: "Maze", image: "maze"),
                            SizedBox(width: 20,),
                            _Card(title: "Coloring Book", image: "coloring_book"),
                          ],
                        ),
                      )
                    ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void LoginAlertDialog(BuildContext context){
    showDialog(context: context,
        builder: (ctx) =>
            AlertDialog(
              backgroundColor: lightThemeColor,
                title:  Text("Oops! Hold Up! 🚧", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),),
                content:  Text("Sorry, you need to log in before you can use this feature.", style: TextStyle( fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.center,),
                actions: <Widget> [
                  Center(
                    child: Column(
                      children: [
                        Image.asset("assets/sad_ray.png", width: 150, height: 120,),
                        SizedBox(height: 15,),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                color: themecolor,

                              ),
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child:  Text("Login",  style: TextStyle( fontWeight: FontWeight.w700, color: Colors.black)),

                            )
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                color: themecolor
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child:  Text("No, maybe later.",  style: TextStyle( fontWeight: FontWeight.w700, color: Colors.black),
                            )
                        ),
                        )],
                    ),
                  ),
                ]
            )
    );
  }
}

class _Card extends StatefulWidget{
  const _Card({Key? key, required this.title, required this.image,}) : super(key: key);
  final String title;
  final String image;

  @override
  State<StatefulWidget> createState() {
    return _CardState();
  }
}

class _CardState extends State<_Card> {

  dynamic pages = {"Coloring Book" : COptions(), "Memory Flip" : FlipCardGame(), "Puzzle":POptions(), /* "Maze":MazeGame(), */ "Calm Down Space": MSplashScreen()};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder:(context)=> pages[widget.title]),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 154,
              height: 120,
              decoration: BoxDecoration(
                color: darkThemeColor,
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFFffe26d),
                    Color(0xFFffab77),
                  ],
                )
              ),
              child:
              Image.asset("assets/${widget.image}.png",height: 120,width: 120,),
            ),
            Container(
              color: Colors.transparent,
              width: 150,
              height: 55,
              alignment: Alignment.center,
              child: Text(widget.title,
                style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

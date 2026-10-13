import '/colors.dart';
import '/Home/Meditation/meditation%20instructions.dart';
import 'package:flutter/material.dart';

class MOptions extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MOptionsState();
  }
}

class _MOptionsState extends State<MOptions>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themecolor,
        title: Text("Meditation",style: TextStyle(fontWeight: FontWeight.w700),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Card(title: "Aura", image: "Meditation-1"),
                  SizedBox(width: 40,),
                  _Card(title: "Nature", image: "Meditation-2"),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Card(title: "Autumn", image: "Meditation-3"),
                  SizedBox(width: 40,),
                  _Card(title: "Twilight", image: "Meditation-5"),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Card(title: "Sunset", image: "Meditation-4"),
                  SizedBox(width: 40,),
                  _Card(title: "Starlight", image: "Meditation-6"),
                ],
              ),
            ],
          ),
        ),
      ),
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

  // dynamic pages = {"Coloring Book" : ColorBook(), "Memory Flip" : FlipCardGame(), "Puzzle":JigSawPuzzlePage(),"Calm Down Space":MSplashScreen()};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width/2-40,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: (){
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder:(context)=> MInstructions(audio_name: widget.title,)),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/2-40,
              height: 120,
              decoration: BoxDecoration(
                  color: darkThemeColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
              Image.asset("assets/meditation_images/${widget.image}.png",height: 120,width: 120,),
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
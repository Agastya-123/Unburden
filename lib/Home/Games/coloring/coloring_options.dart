import '/Home/Games/coloring/colorBook.dart';
import '/Home/Games/puzzle/jigsaw_puzzle.dart';
import '/colors.dart';
import '/Home/Meditation/meditation%20instructions.dart';
import 'package:flutter/material.dart';

class COptions extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _COptionsState();
  }
}

class _COptionsState extends State<COptions>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themecolor,
        title: Text("Coloring Book",style: TextStyle(fontWeight: FontWeight.w700),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Card(image: "cat.jpg"),
                  SizedBox(width: 40,),
                  _Card(image: "dog.png"),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Card(image: "House.png"),
                  SizedBox(width: 40,),
                  _Card(image: "rabbit.png"),
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
  const _Card({Key? key,  required this.image,}) : super(key: key);
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
            MaterialPageRoute(builder:(context)=> ColorBook(image: widget.image,)),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width/2-40,
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
          ClipRRect(
              child: Image.asset("assets/drawing/${widget.image}",),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
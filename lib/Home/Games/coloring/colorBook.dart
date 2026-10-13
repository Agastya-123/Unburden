import '/BottomNav.dart';
import 'package:confetti/confetti.dart';
import 'package:floodfill_image/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../colors.dart';

class ColorBook extends StatefulWidget {

  ColorBook({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  _ColorBookState createState() => _ColorBookState();
}

class _ColorBookState extends State<ColorBook> {
  Color _fillColor = Colors.amber;
  Color pickedColor = Colors.amber;

  void changeColor(Color color) {
    setState(() => pickedColor = color);
  }

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void showCongratsDialog() {
    _confettiController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            AlertDialog(
              backgroundColor: lightThemeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text(
                  "🎉 Congratulations!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              content: Text(
                "You completed coloring!",
                textAlign: TextAlign.center,
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themecolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePageScreen()));
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                  numberOfParticles: 30,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coloring Book"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                height: 300,
                child: FloodFillImage(
                  imageProvider: AssetImage("assets/drawing/${widget.image}"),
                  fillColor: _fillColor,
                  avoidColor: [Colors.transparent, Colors.black],
                  tolerance: 10,
                ),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: _fillColor,
                            onColorChanged: changeColor,
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Got it',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themecolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              minimumSize: const Size(70, 20),
                              elevation: 5,
                            ),
                            onPressed: () {
                              setState(() => _fillColor = pickedColor);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                   },
                  child: Text("Pick Color",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
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
              SizedBox(height: 50,),
              ElevatedButton(
                  onPressed: (){
                    showCongratsDialog();
                  },
                  child: Text("Done!",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
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
        ),
      ),
    );
  }
}
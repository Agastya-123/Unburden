import 'package:confetti/confetti.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../BottomNav.dart';
import '../../colors.dart';
import 'data.dart';
import 'dart:async';

class FlipCardGame extends StatefulWidget {
  @override
  _FlipCardGameState createState() => _FlipCardGameState();
}

class _FlipCardGameState extends State<FlipCardGame> {

  int _previousIndex = -1;
  bool _flip = false;
  bool _start = false;

  bool _wait = false;
  String _level = "medium";
  late Timer _timer;
  int _time = 5;
  late int _left;
  late bool _isFinished;
  late List<dynamic> _data;

  late List<bool> _cardFlips;

  late ConfettiController _confettiController;

  late List<GlobalKey<FlipCardState>> _cardStateKeys;

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 3,
              spreadRadius: 0.8,
              offset: Offset(2.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.all(4.0),
      child: Image.asset(_data[index]),
    );
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _time = _time - 1;
      });
    });
  }

  void restart() {
    startTimer();
    _data = getSourceArray(_level);
    _cardFlips = getInitialItemState(_level);
    _cardStateKeys = getCardStateKeys(_level);
    _time = 3;
    _left = (_data.length ~/ 2);

    _isFinished = false;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _start = true;
        _timer.cancel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    restart();
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
                "You matched everything!",
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
    return _isFinished
        ? Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    restart();
                  });
                },
                child: Container(
                  height: 50,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    "Replay",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: themecolor,
              title: Text("Memory Flip", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700),),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _time > 0
                            ? Text(
                                '$_time', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                              )
                            : Text(
                                'Left: $_left', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) => _start
                              ? FlipCard(
                                  key: _cardStateKeys[index],
                                  onFlip: () {
                                    if (!_flip) {
                                      _flip = true;
                                      _previousIndex = index;
                                    } else {
                                      _flip = false;
                                      if (_previousIndex != index) {
                                        if (_data[_previousIndex] !=
                                            _data[index]) {
                                          _wait = true;

                                          Future.delayed(
                                              const Duration(milliseconds: 1500),
                                              () {
                                            _cardStateKeys[_previousIndex]
                                                .currentState
                                                ?.toggleCard();
                                            _previousIndex = index;
                                            _cardStateKeys[_previousIndex]
                                                .currentState
                                                ?.toggleCard();

                                            Future.delayed(
                                                const Duration(milliseconds: 160),
                                                () {
                                              setState(() {
                                                _wait = false;
                                              });
                                            });
                                          });
                                        } else {
                                          _cardFlips[_previousIndex] = false;
                                          _cardFlips[index] = false;
                                          print(_cardFlips);

                                          setState(() {
                                            _left -= 1;
                                          });
                                          if (_cardFlips
                                              .every((t) => t == false)) {
                                            print("Won");
                                            Future.delayed(
                                                const Duration(milliseconds: 160),
                                                () {
                                             showCongratsDialog();
                                            });
                                          }
                                        }
                                      }
                                    }
                                    setState(() {});
                                  },
                                  flipOnTouch: _wait ? false : _cardFlips[index],
                                  direction: FlipDirection.HORIZONTAL,
                                  front: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color(0xFFffe26d).withOpacity(0.8),
                                            Color(0xFFffab77),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 3,
                                            spreadRadius: 0.8,
                                            offset: Offset(2.0, 1),
                                          )
                                        ]),
                                    margin: EdgeInsets.all(4.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "assets/animalspics/panda_memory.png",
                                      ),
                                    ),
                                  ),
                                  back: getItem(index))
                              : getItem(index),
                          itemCount: _data.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

import '/colors.dart';
import 'package:flutter/material.dart';
import '../ChatBot/chatbot.dart';

class Jread extends StatefulWidget {

  final String data;
  const Jread({super.key, required this.data});

  @override
  State createState() => _JreadState();
}

class _JreadState extends State<Jread> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: themecolor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Image.asset("assets/journal_frame.png",),
                  ),
                  Positioned(
                    top: 130,
                    left: 30,
                    right: 30,
                    bottom: 120,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.data, style: TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void chatbotDialog(BuildContext context, String text, String response) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Ray's Here",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
        ),
        content: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: Column(
              children: [
                Image.asset("assets/ray.png", width: 150, height: 150),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ChatScreen(task: "journal", text: response)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: themecolor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "Yes, let's talk.",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: themecolor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "No, maybe later.",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import "dart:async";

import "/ChatBot/chatbot.dart";
import "/Journal/journal.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:google_nav_bar/google_nav_bar.dart";

import "Authentication/login_email.dart";
import "Information Module/info.dart";
import "colors.dart";
import "Home/home.dart";

class HomePageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageScreenState();
  }
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;
  User? user = FirebaseAuth.instance.currentUser;
  late final StreamSubscription<User?> _authSubscription;

  static List<Widget> _pages = <Widget>[
    Home(),
    ChatScreen(task: "", text: ""),
    Journal(),
    InfoScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? newUser) {
      setState(() {
        user = newUser;
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if ((index == 1 || index == 2) && user == null) {
      LoginAlertDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            top: BorderSide(
              color: themecolor,
              width: 2.0,
            ),
          ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            color: themecolor,
            iconSize: 28,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            duration: Duration(milliseconds: 800),
            tabBackgroundColor: themecolor,
            tabs: [
              GButton(icon: FontAwesomeIcons.houseChimney, text: 'Home'),
              GButton(icon: FontAwesomeIcons.android, text: 'Chatbot'),
              GButton(icon: Icons.book_rounded, text: 'Journal'),
              GButton(icon: FontAwesomeIcons.solidClipboard, text: "Guidelines"),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }


  void LoginAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: lightThemeColor,
        title: Text(
          "Oops! Hold Up! 🚧",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
        ),
        content: Text(
          "Sorry, you need to log in before you can use this feature.",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: Column(
              children: [
                Image.asset("assets/sad_ray.png", width: 150, height: 120),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: themecolor,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: themecolor,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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


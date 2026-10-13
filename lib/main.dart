import "dart:async";

import "/Home/home.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:hive_flutter/hive_flutter.dart";

import "Authentication/personal details.dart";
import "BottomNav.dart";
import "firebase_options.dart";
import "getstartedscreen.dart";


Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    await Hive.initFlutter();
    
    await Hive.openBox('journals');
    await Hive.openBox('challenge_completions');
    
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Anti-Bully",
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    start_();
  }

  Future<void> start_() async {
    await Future.delayed(Duration(seconds: 2));

    bool isLoggedIn = await checkAnonymousLogin();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStartedScreen()),
      );
    }
  }

  Future<bool> checkAnonymousLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    final nickname = prefs.getString('username') ?? "";
    print(nickname);
    return nickname.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.7,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/logo_1.png"),
        fit: BoxFit.contain,
            ),
            ),
        ),
      ),
    );
  }
}

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/BottomNav.dart';
import '/getstartedscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/login_email.dart';
import '../colors.dart';
import 'About_us.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Contact_us.dart';
import 'ProfileMenuWidget.dart';
import 'UpdateProfile.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;

  final Uri url = Uri.parse("https://janhavikarande07.github.io/Unburden_Policy/");

  Future<void> _openInBrowser() async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> data = {};
    try {
      DocumentReference docRef =
      FirebaseFirestore.instance.collection("Users").doc(user?.uid);
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        dynamic fieldValue = snapshot.data();
        if (fieldValue != null) {
          data = fieldValue;
        }
      }
      else{
        final prefs = await SharedPreferences.getInstance();
        // await prefs.clear();
        final nickname = prefs.getString('username') ?? "";
       data = {"name": nickname};
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
        centerTitle: true,
        backgroundColor: themecolor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile'));
          }

          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data ?? {};

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // SizedBox(height: 10),
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            // borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "assets/panda_welcome.png",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    const SizedBox(height: 5,),
                    Text(
                      data["name"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if(user == null){
                          LoginAlertDialog(context);
                        }
                        else {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateProfileScreen(profileData: data),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themecolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 50),
                        shadowColor: lightThemeColor,
                        elevation: 5,
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Cooper",
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                        title: "About Us",
                        icon: Icons.info,
                        onPress: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AboutUsScreen(),
                            ),
                          );
                        }),
                    ProfileMenuWidget(
                        title: "Contact Us",
                        icon: Icons.perm_contact_cal,
                        onPress: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ContactUsScreen(),
                            ),
                          );
                        }),
                    ProfileMenuWidget(
                        title: "Privacy Policy",
                        icon: Icons.security,
                        onPress: _openInBrowser,
                    ),
                    ProfileMenuWidget(
                      title: "Delete Account",
                      icon: FontAwesomeIcons.trash,
                      onPress: (){
                        _showDeleteAccountDialog(context);
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                        title: (user == null) ? "Login":"Logout",
                        icon: (user == null) ? Icons.login : Icons.logout,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          if(user == null){
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>  LoginPage()),
                            );
                          }
                          else{
                            FirebaseAuth.instance.signOut();
                            print('Logged out');
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>  HomePageScreen()
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('No profile data found'));
        },
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
                        )
                      ],
                    ),
                  ),
                ]
            )
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
            'This will permanently delete your account and related data. '
                'This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await deleteAccount();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('username');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GetStartedScreen()));
      }
      else {
        await FirebaseFirestore.instance.collection("Users")
            .doc(user.uid)
            .delete();
        final db = FirebaseFirestore.instance;

        final querySnap = await db
            .collection("journals")
            .where("uid", isEqualTo: user.uid)
            .get();

        final batch = db.batch();

        for (final doc in querySnap.docs) {
          batch.delete(doc.reference);
        }

        await batch.commit();
        await FirebaseAuth.instance.signOut();

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('username');

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GetStartedScreen()));
      }
    } on FirebaseException catch (e) {
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message:
          'Something went wrong. Try again...',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } on Exception catch(e){
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message:
          'Something went wrong. Try again...',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }







  }


}
import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '/Authentication/personal%20details.dart';

import '../BottomNav.dart';
import 'login_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validation_textformfield/validation_textformfield.dart';

import '/colors.dart';

class RegisterPage extends StatefulWidget {

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController? emailController, passwordController, confirmPasswordController;
  double screenHeight = 0;
  double screenWidth = 0;
  bool isObscure = true;
  bool isObscureCP = true;
  bool showvalue = false;

  final FirebaseFirestore firestore= FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 30,
          leading:
            IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePageScreen()));
                },
                icon: Icon(FontAwesomeIcons.xmark)
            ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Image.asset("assets/Ray-M.png", width: 100,),
                  ),
                  SizedBox(height: 30,),
                  const Text(
                    "REGISTER",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Cooper", fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  EmailValidationTextField(
                    whenTextFieldEmpty: "Please enter  email",
                    validatorMassage: "Please enter valid email",
                    decoration: InputDecoration(
                        labelText: ' Email ',
                        labelStyle: TextStyle(
                          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                          fontFamily: "Cooper",
                          fontStyle: FontStyle.normal,
                        ),
                        prefixIcon: Icon(Icons.email_rounded, color: Colors.black,),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themecolor),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: themecolor),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: themecolor),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        counterText: '',
                        hintStyle: TextStyle(color: Colors.black, fontSize: 18.0)
                    ),
                    textEditingController: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height : 20),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      PassWordValidationTextFiled(
                        lineIndicator:false,
                        passwordMinError: "Must be more than 6 characters",
                        hasPasswordEmpty: "Password is Empty",
                        passwordMaxError: "Password too Long",
                        passWordUpperCaseError: "At least one Uppercase(Capital) letter",
                        passWordDigitsCaseError: "At least one digit",
                        passwordLowercaseError: "At least one lowercase character",
                        passWordSpecialCharacters: "At least one Special Characters",
                        obscureText: isObscure,
                        scrollPadding: const EdgeInsets.only(left: 60),
                        // onChanged: (value) {
                        //   // print(value);
                        // },
                        passTextEditingController: passwordController,
                        passwordMaxLength: 12,
                        passwordMinLength: 6,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: ' Password ',
                            labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                              fontFamily: "Cooper",
                              fontStyle: FontStyle.normal,
                            ),
                            prefixIcon: const Icon(Icons.password_outlined, color: Colors.black,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themecolor),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themecolor),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: themecolor),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            counterText: '',
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 18.0)
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            // color: Colors.white,
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                icon: isObscure ? Icon(FontAwesomeIcons.eye, size: 22,) : Icon(FontAwesomeIcons.eyeSlash, size: 22,)
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height : 20),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ConfirmPassWordValidationTextFromField(
                        obscureText: isObscureCP,
                        // obscureText: _isObscure,
                        scrollPadding: EdgeInsets.only(left: 60),
                        // onChanged: (value) {
                        // // print(value);
                        // },
                        whenTextFieldEmpty: "Cannot be Empty",
                        validatorMassage: "Password do not Match",
                        confirmtextEditingController: confirmPasswordController,
                        decoration: InputDecoration(
                            labelText: ' Confirm Password ',
                            labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                              fontFamily: "Cooper",
                              fontStyle: FontStyle.normal,
                            ),
                            prefixIcon: const Icon(Icons.password_rounded, color: Colors.black,),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themecolor),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: themecolor),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: themecolor),
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            counterText: '',
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 18.0)
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            // color: Colors.white,
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isObscureCP = !isObscureCP;
                                  });
                                },
                                icon: isObscureCP ? Icon(FontAwesomeIcons.eye, size: 22,) : Icon(FontAwesomeIcons.eyeSlash, size: 22,)
                            )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50,),
                  ElevatedButton(
                    onPressed: () async{

                      print(emailController!.text);
                      print(passwordController!.text);

                      showDialog(context: context, builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });

                      try {

                        if(emailController!.text.isEmpty || passwordController!.text.isEmpty || confirmPasswordController!.text.isEmpty){
                          const snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Error!',
                              message:
                              'Please enter valid credentials...',
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }

                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController!.text,
                          password: passwordController!.text,
                        );

                        User? user = FirebaseAuth.instance.currentUser;

                        Map<String, dynamic> data = {
                          "email": emailController?.text,
                          "name": "",
                          "age": "",
                          "guardian_contact_no" : "",
                          "guardian_email_id" : "",
                        };

                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(user!.uid)
                            .set(data);

                        Navigator.pop(context);

                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PersonalDetailsPage(),
                          ),
                        );

                      } on FirebaseAuthException catch (e) {
                        Navigator.pop(context);

                        print(e.code);
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themecolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minimumSize: const Size(double.infinity, 50),
                      // textStyle: TextStyle(fontSize: 14),
                      shadowColor: darkThemeColor,
                      elevation: 5,
                    ),
                    child: const Text("REGISTER",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Cooper",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey[400], thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey[400], thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Colors.red,
                      size: 20,
                    ),
                    label: const Text(
                      "Continue with Google",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontFamily: "Cooper",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey[300]!, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 1,
                    ),
                  ),
                  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _signInWithApple,
                      icon: const Icon(
                        FontAwesomeIcons.apple,
                        color: Colors.black,
                        size: 22,
                      ),
                      label: const Text(
                        "Continue with Apple",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontFamily: "Cooper",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey[300]!, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 1,
                      ),
                    ),
                  ],
                  const SizedBox(height : 20),
                  const SizedBox(height: 30,),
                  InkWell(
                    onTap: () async{
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child:
                    EasyRichText(
                      "Already have an account? Login...",
                      defaultStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Cooper",
                        fontStyle: FontStyle.normal,
                      ),
                      patternList: [
                        EasyRichTextPattern(
                            targetString: 'Login...',
                            style: TextStyle(fontWeight: FontWeight.w900, color: themecolor)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Navigator.pop(context);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;
      
      bool hasPersonalDetails = false;
      if (user != null) {
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();
          
          if (userDoc.exists) {
            Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
            if (userData != null && 
                userData.containsKey('name') && 
                userData['name'] != null && 
                userData['name'].toString().trim().isNotEmpty) {
              hasPersonalDetails = true;
            } else {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .set({
                    "email": user.email ?? "",
                    "name": "",
                    "age": "",
                    "guardian_contact_no": "",
                    "guardian_email_id": "",
                  }, SetOptions(merge: true));
            }
          } else {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .set({
                  "email": user.email ?? "",
                  "name": "",
                  "age": "",
                  "guardian_contact_no": "",
                  "guardian_email_id": "",
                });
          }
        } catch (e) {
          print("Error checking user details: $e");
        }
      }

      Navigator.pop(context);

      if (context.mounted) {
        if (hasPersonalDetails) {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePageScreen(),
            ),
          );
        } else {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PersonalDetailsPage(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print("error : $e");
      String errorMessage = 'Something went wrong. Try again...';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'An account already exists with a different sign-in method.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid credential. Please try again.';
      }
      print(errorMessage);

      if (context.mounted) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: errorMessage,
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      Navigator.pop(context);
      print("fdsjd $e");
      if (context.mounted) {
        const snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Something went wrong. Try again...',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }

  Future<void> _signInWithApple() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      User? user = userCredential.user;
      bool hasPersonalDetails = false;
      if (user != null) {
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            Map<String, dynamic>? userData =
                userDoc.data() as Map<String, dynamic>?;
            if (userData != null &&
                userData.containsKey('name') &&
                userData['name'] != null &&
                userData['name'].toString().trim().isNotEmpty) {
              hasPersonalDetails = true;
            } else {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .set({
                    "email": user.email ?? "",
                    "name": "",
                    "age": "",
                    "guardian_contact_no": "",
                    "guardian_email_id": "",
                  }, SetOptions(merge: true));
            }
          } else {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(user.uid)
                .set({
                  "email": user.email ?? "",
                  "name": "",
                  "age": "",
                  "guardian_contact_no": "",
                  "guardian_email_id": "",
                });
          }
        } catch (e) {
          print("Error checking user details: $e");
        }
      }

      Navigator.pop(context);

      if (context.mounted) {
        if (hasPersonalDetails) {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePageScreen(),
            ),
          );
        } else {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PersonalDetailsPage(),
            ),
          );
        }
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      Navigator.pop(context);
      if (e.code == AuthorizationErrorCode.canceled) {
        return;
      }
      if (context.mounted) {
        const snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Apple sign in failed. Try again...',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage = 'Something went wrong. Try again...';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage =
            'An account already exists with a different sign-in method.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid credential. Please try again.';
      }
      if (context.mounted) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: errorMessage,
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      Navigator.pop(context);
      if (context.mounted) {
        const snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Something went wrong. Try again...',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }
}


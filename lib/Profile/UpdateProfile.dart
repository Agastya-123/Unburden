import 'package:validation_textformfield/validation_textformfield.dart';

import '../colors.dart';
import 'Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateProfileScreen extends StatefulWidget{

  final Map<String, dynamic> profileData;
  const UpdateProfileScreen({super.key, required this.profileData});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  TextEditingController nameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  TextEditingController guardian_phone_numberController=TextEditingController();
  TextEditingController guardian_emailController=TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  
  @override
  void initState() {
    nameController = TextEditingController(text : widget.profileData["name"]);
    ageController = TextEditingController(text: widget.profileData["age"]);
    guardian_emailController = TextEditingController(text: widget.profileData["guardian_email_id"]);
    guardian_phone_numberController = TextEditingController(text: widget.profileData["guardian_contact_no"]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Details", style: TextStyle(fontWeight: FontWeight.w700),),
        backgroundColor: themecolor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              SizedBox(height: 30,),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: ' Name ',
                  labelStyle: const TextStyle(
                    color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                    fontFamily: "Cooper",
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.black,),
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
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: ' Age ',
                  labelStyle: const TextStyle(
                    color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                    fontFamily: "Cooper",
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.black,),
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
                ),
              ),
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Divider(color: themecolor, thickness: 3,),
              ),
              SizedBox(height: 40,),
              Text("We need your guardian’s details so we can reach out if something seems wrong. Don’t worry, it’s just to keep you safe!", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              // SizedBox(height: 40,),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30),
              //   child: Divider(color: themecolor, thickness: 3,),
              // ),
              SizedBox(height: 40,),
              TextFormField(
                controller: guardian_phone_numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: ' Guardian Phone Number ',
                  labelStyle: const TextStyle(
                    color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                    fontFamily: "Cooper",
                    fontStyle: FontStyle.normal,
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.black,),
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
                ),
              ),
              SizedBox(height: 20,),
              EmailValidationTextField(
                whenTextFieldEmpty: "Please enter  email",
                validatorMassage: "Please enter valid email",
                decoration: InputDecoration(
                    labelText: ' Guardian Email ',
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
                // textEditingController: emailController,
                textEditingController: guardian_emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () async{
                  if (nameController.text.isEmpty ||
                      ageController.text.isEmpty ||
                      guardian_phone_numberController.text.isEmpty ||
                      guardian_emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill out all the fields!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  showDialog(context: context, builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  });
                  try {
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
                        "name": nameController.text,
                        "age": ageController.text,
                        "guardian_contact_no": guardian_phone_numberController.text,
                        "guardian_email_id": guardian_emailController.text,
                      });
                    }

                    Navigator.pop(context);

                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Profile(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    Navigator.pop(context);

                    print(e.code);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Either Username or Password is Incorrect!'),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                          },
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themecolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  minimumSize: const Size(200, 30),
                  // textStyle: TextStyle(fontSize: 14),
                  shadowColor: darkThemeColor,
                  elevation: 5,
                ),
                child: const Text("Save",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Cooper",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
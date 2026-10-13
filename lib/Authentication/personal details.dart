import '../secrets.dart';
import 'dart:async';
import 'dart:math';
import '/BottomNav.dart';

import '../Home/home.dart';
import '/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:validation_textformfield/validation_textformfield.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class PersonalDetailsPage extends StatefulWidget {

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {

  TextEditingController nameController=TextEditingController();
  TextEditingController ageController=TextEditingController();
  TextEditingController guardian_phone_numberController=TextEditingController();
  TextEditingController guardian_emailController=TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool _isEmailSent = false;
  bool _isOtpSending = false;
  bool _isOtpVerifying = false;
  bool _isGuardianEmailVerified = false;
  String? _generatedOtp;
  DateTime? _otpExpiry;
  String? _otpSentTo;

  @override
  void initState() {
    super.initState();
    guardian_emailController.addListener(() {
      if (_otpSentTo != null &&
          guardian_emailController.text.trim() != _otpSentTo &&
          _isGuardianEmailVerified) {
        setState(() {
          _isGuardianEmailVerified = false;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    guardian_phone_numberController.dispose();
    guardian_emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  String _generateOtp() {
    final random = Random.secure();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<bool> _sendVerificationEmail(String guardianEmail, String childName, String otp) async {
    try {
      const String smtpHost = 'smtp.gmail.com';
      const int smtpPort = 587;
      const String smtpUsername = Secrets.smtpUsername;
      const String smtpPassword = Secrets.smtpPassword;
      const String fromEmail = 'unburden.antibullying@gmail.com';
      const String fromName = 'Unburden App';
      
      final smtpServer = SmtpServer(
        smtpHost,
        port: smtpPort,
        username: smtpUsername,
        password: smtpPassword,
      );

      final message = Message()
        ..from = Address(fromEmail, fromName)
        ..recipients.add(guardianEmail)
        ..subject = 'Your Unburden Guardian Verification OTP'
        ..html = '''
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <style>
              body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
              .container { max-width: 600px; margin: 0 auto; padding: 20px; }
              .header { background: linear-gradient(135deg, #fb9d69 0%, #ebab9c 100%); color: white; padding: 25px; border-radius: 10px 10px 0 0; text-align: center; }
              .content { background: #ffffff; padding: 30px; border: 1px solid #e0e0e0; border-top: none; }
              .info-box { background: #fff3cd; border-left: 5px solid #ffc107; padding: 15px; margin: 20px 0; border-radius: 5px; }
              .otp-box { background: #fff8e1; border: 2px dashed #ff9800; padding: 20px; margin: 20px 0; border-radius: 8px; text-align: center; }
              .otp-code { font-size: 30px; letter-spacing: 8px; font-weight: bold; color: #e65100; margin: 8px 0; }
              .footer { background: #f5f5f5; padding: 20px; text-align: center; border-radius: 0 0 10px 10px; color: #666; font-size: 12px; }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="header">
                <h1>Hello! 👋</h1>
                <p style="margin: 10px 0 0 0; font-size: 16px;">Unburden App - Guardian Verification</p>
              </div>
              
              <div class="content">
                <p>Hello,</p>

                <p><strong>$childName</strong> has added you as their trusted guardian on Unburden.</p>

                <div class="otp-box">
                  <p style="margin: 0; font-size: 16px;"><strong>Your verification code (OTP)</strong></p>
                  <div class="otp-code">$otp</div>
                  <p style="margin: 0; font-size: 13px; color: #555;">
                    This code is valid for 10 minutes.
                  </p>
                </div>

                <p>Enter this code in the app to complete your verification.</p>
                
                <div class="info-box">
                  <p style="margin: 0;"><strong>What this means:</strong></p>
                  <p style="margin: 10px 0 0 0;">
                    As a trusted guardian, you may be contacted if $childName needs urgent support.
                    We only share limited, relevant information in such situations to help you respond appropriately.
                    All other data remains private.
                  </p>
                </div>

                <p>If you did not expect this request, you can safely ignore this email.</p>

                <p style="margin-top: 30px;">Take care,<br><strong>The Unburden Team</strong></p>
              </div>
              
              <div class="footer">
                <p>This is an automated verification email from the Unburden App</p>
                <p>If you did not expect this email, please ignore it.</p>
              </div>
            </div>
          </body>
          </html>
        '''
        ..text = '''
          Hello,

          $childName has added you as their trusted guardian on Unburden.

          Your verification code (OTP): $otp
          This OTP is valid for 10 minutes.
          Enter this code in the app to complete your verification.

          What this means:
          As a trusted guardian, you may be contacted if $childName needs urgent support.
          We only share limited, relevant information in such situations to help you respond appropriately.
          All other data remains private.

          If you did not expect this request, you can safely ignore this email.

          Take care,
          The Unburden Team

          ---
          This is an automated verification email from the Unburden App
          If you did not expect this email, please ignore it.
        ''';

      await send(message, smtpServer);
      print("✅ Verification email sent to $guardianEmail");
      return true;
    } catch (e) {
      print("❌ Error sending verification email: $e");
      return false;
    }
  }

  Future<void> _handleSendOtp() async {
    final String guardianEmail = guardian_emailController.text.trim();
    final String childName = nameController.text.trim();

    if (guardianEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter guardian email first.')),
      );
      return;
    }
    if (childName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first.')),
      );
      return;
    }

    setState(() {
      _isOtpSending = true;
      _isGuardianEmailVerified = false;
      _isEmailSent = false;
      _generatedOtp = null;
      _otpExpiry = null;
      _otpSentTo = null;
      otpController.clear();
    });

    final String otp = _generateOtp();
    final bool sent = await _sendVerificationEmail(guardianEmail, childName, otp);

    if (!mounted) return;

    setState(() {
      _isOtpSending = false;
      _isEmailSent = sent;
      if (sent) {
        _generatedOtp = otp;
        _otpExpiry = DateTime.now().add(const Duration(minutes: 10));
        _otpSentTo = guardianEmail;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent
              ? 'OTP sent to guardian email.'
              : 'Failed to send OTP. Please try again.',
        ),
        backgroundColor: sent ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _handleVerifyOtp() async {
    final enteredOtp = otpController.text.trim();
    if (_generatedOtp == null || _otpExpiry == null || _otpSentTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please send OTP first.')),
      );
      return;
    }
    if (guardian_emailController.text.trim() != _otpSentTo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guardian email changed. Please resend OTP.')),
      );
      return;
    }
    if (enteredOtp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP.')),
      );
      return;
    }

    setState(() {
      _isOtpVerifying = true;
    });

    final bool isExpired = DateTime.now().isAfter(_otpExpiry!);
    final bool isValid = !isExpired && enteredOtp == _generatedOtp;

    if (!mounted) return;

    setState(() {
      _isOtpVerifying = false;
      _isGuardianEmailVerified = isValid;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isValid
              ? 'Guardian email verified successfully.'
              : isExpired
                  ? 'OTP expired. Please resend OTP.'
                  : 'Invalid OTP. Please try again.',
        ),
        backgroundColor: isValid ? Colors.green : Colors.red,
      ),
    );

    if (!isValid && isExpired) {
      setState(() {
        _generatedOtp = null;
        _otpExpiry = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Personal Details", style: TextStyle(fontWeight: FontWeight.w700),),
       automaticallyImplyLeading: false,
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
             Container(
               padding: EdgeInsets.all(20),
               decoration: BoxDecoration(
                 color: lightThemeColor,
                 borderRadius: BorderRadius.circular(15),
                 border: Border.all(color: themecolor.withOpacity(0.3), width: 2),
               ),
               child: Column(
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Image.asset("assets/panda_welcome.png", width: 50,),
                       SizedBox(width: 10,),
                       Text(
                         "Hey there!",
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.w700,
                           color: Colors.black87,
                         ),
                       ),
                     ],
                   ),
                   SizedBox(height: 15),
                   Text(
                     "We care about you, and we want to respect your privacy. But safety comes first.\n\n"
                     "We need the details of a trusted adult (18+) who you'd like us to reach out to in a crisis. "
                     "Whenever we feel like you might be in emotional or physical distress, we'll send them an alert.\n\n"
                     "Rest assured - all your data stays private. Only the context of that specific trigger will be shared with your guardian in an emergency situation.",
                     style: TextStyle(
                       fontSize: 15,
                       height: 1.5,
                       color: Colors.black87,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ],
               ),
             ),
             SizedBox(height: 30,),
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
             SizedBox(height: 14,),
             Row(
               children: [
                 Expanded(
                   child: ElevatedButton.icon(
                     onPressed: _isOtpSending ? null : _handleSendOtp,
                     icon: _isOtpSending
                         ? const SizedBox(
                             width: 16,
                             height: 16,
                             child: CircularProgressIndicator(strokeWidth: 2),
                           )
                         : const Icon(Icons.mark_email_read_outlined),
                     label: Text(_isEmailSent ? "Resend OTP" : "Send OTP"),
                     style: ElevatedButton.styleFrom(
                       backgroundColor: themecolor,
                       foregroundColor: Colors.black,
                     ),
                   ),
                 ),
               ],
             ),
             SizedBox(height: 16,),
             Align(
               alignment: Alignment.centerLeft,
               child: Text(
                 "Enter OTP sent to guardian email",
                 style: TextStyle(
                   fontWeight: FontWeight.w600,
                   color: Colors.black87,
                 ),
               ),
             ),
             SizedBox(height: 10),
             Pinput(
               controller: otpController,
               length: 6,
               keyboardType: TextInputType.number,
               inputFormatters: [FilteringTextInputFormatter.digitsOnly],
               onChanged: (_) {
                 if (_isGuardianEmailVerified) {
                   setState(() {
                     _isGuardianEmailVerified = false;
                   });
                 }
               },
             ),
             SizedBox(height: 12),
             Row(
               children: [
                 Expanded(
                   child: ElevatedButton(
                     onPressed: _isOtpVerifying ? null : _handleVerifyOtp,
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.black87,
                       foregroundColor: Colors.white,
                     ),
                     child: _isOtpVerifying
                         ? const SizedBox(
                             width: 16,
                             height: 16,
                             child: CircularProgressIndicator(
                               strokeWidth: 2,
                               color: Colors.white,
                             ),
                           )
                         : const Text("Verify OTP"),
                   ),
                 ),
               ],
             ),
             SizedBox(height: 10),
             if (_isGuardianEmailVerified)
               const Text(
                 "Guardian email verified",
                 style: TextStyle(
                   color: Colors.green,
                   fontWeight: FontWeight.w600,
                 ),
               ),
             SizedBox(height: 40,),
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
                 if (!_isGuardianEmailVerified) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       content: Text('Please verify guardian email OTP before saving.'),
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
                       "guardian_email_verified": true,
                       "guardian_email_verified_at": FieldValue.serverTimestamp(),
                     });
                   }
       
                   Navigator.pop(context);

                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       content: Text('Details saved! Guardian email verified.'),
                       backgroundColor: Colors.green,
                       duration: Duration(seconds: 3),
                     ),
                   );
       
                   await Navigator.of(context).push(
                     MaterialPageRoute(
                       builder: (context) => HomePageScreen(),
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
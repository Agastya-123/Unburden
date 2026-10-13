import 'package:flutter/material.dart';
import '../colors.dart';

class ContactUsScreen extends StatefulWidget{
  const ContactUsScreen({super.key});


  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final String email = "agastya0412@gmail.com";


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themecolor,
        title: Text("Contact Us", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, ), textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body : SingleChildScrollView(
        child : Center(
          child : Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30,),
                Image.asset("assets/ray.png", width: 200, height: 200,),
                const SizedBox(height: 30,),
                const Text("Feel free to reach out if you have any questions or need assistance:",
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                // InkWell(
                //   onTap: () => _launchPhoneCall(phoneNumber),
                //   child: Row(
                //     children: [
                //       Icon(Icons.phone, color: Colors.blue),
                //       SizedBox(width: 10),
                //       Text(
                //         phoneNumber,
                //         style: TextStyle(
                //           fontSize: 18,
                //
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, color: themecolor),
                    SizedBox(width: 10),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
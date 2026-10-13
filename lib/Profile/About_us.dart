import 'package:flutter/material.dart';

import '../colors.dart';

class AboutUsScreen extends StatefulWidget{
  const AboutUsScreen({super.key});


  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themecolor,
        title: Text("About Us", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24,), textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body : SingleChildScrollView(
        child : Center(
          child : Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child : Column(
              children: [
                const SizedBox(height: 30,),
                Image.asset("assets/ray.png", width: 150, height: 100,),
                SizedBox(height: 20),
                Text("Unburden", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: themecolor), textAlign: TextAlign.center,),
                // const SizedBox(height: 10,),
                // const Text("Accurate Injury Insights,\n Anytime, Anywhere", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF116796)), textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                const Text("At Unburden, we believe every young person deserves to feel safe, confident, and heard. Our mission is to support children and teens who have experienced bullying by offering tools that build resilience, boost self-esteem, and create a positive mindset — all in a fun, interactive way. "
                    "\n\nI created Unburden after experiencing bullying myself. I know how painful and isolating it can be, and I wanted to turn that experience into something positive for others. Unburden offers daily confidence-building challenges, emotional support resources, and a safe space to grow. "
                    "\n\nTogether, we’re changing the way the world deals with bullying — with courage and kindness."
                  , style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,)
              ],
            )
          ),
        ),
      ),
    );
  }
}
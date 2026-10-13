import 'package:flutter/material.dart';

import '../colors.dart';

class Types extends StatefulWidget {
  @override
  State createState() => _TypesState();
}

class _TypesState extends State<Types> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themecolor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text("Types of Bullying", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20), textAlign: TextAlign.center),
                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: Image.asset("assets/info/type.png"),
                ),
                SizedBox(height: 24,),
                Text("Bullying does not always look the same. Many people imagine bullying as physical fighting or pushing, but in reality it can happen in several different ways. Sometimes bullying is visible and direct, while other times it happens through words, relationships, or online interactions.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("One common form is physical bullying. This involves harming someone's body or belongings. Actions such as hitting, pushing, kicking, tripping, or damaging someone's possessions are examples of physical bullying. Because it involves physical force, this type of bullying is often easier for teachers or adults to notice.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("Another type is verbal bullying, which uses words to hurt or humiliate someone. This may include name-calling, insults, threats, or repeated teasing about someone's appearance, abilities, or background. Although verbal bullying does not leave physical injuries, it can have a strong emotional impact and affect a person's confidence.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("Bullying can also occur through social or relational behavior. Social bullying focuses on damaging a person's relationships or reputation. For example, someone might spread rumors, encourage others to exclude a classmate from activities, or publicly embarrass them. These actions can make the targeted person feel isolated and rejected.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("In recent years, another form called cyberbullying has become increasingly common. Cyberbullying happens through digital platforms such as social media, messaging apps, online games, or text messages. Harmful comments, threatening messages, sharing embarrassing photos, or spreading rumors online are all examples of cyberbullying.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 14,),
                Text("Although these types of bullying may appear different, they all share the same goal: to harm, control, or intimidate another person. Recognizing these different forms helps students understand that bullying is not limited to physical aggression and that emotional harm can be just as serious.", style: TextStyle(fontSize: 15, height: 1.4)),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: lightThemeColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: themecolor.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Key Idea", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: themecolor)),
                      SizedBox(height: 6),
                      Text("Bullying can occur in many forms, including physical, verbal, social, and online behaviors, but all forms involve intentional harm toward another person.", style: TextStyle(fontSize: 15, height: 1.4, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text("Adapted from research and educational resources provided by: American Psychological Association; StopBullying.gov; Centers for Disease Control and Prevention Youth Violence Prevention resources; UNESCO reports on school bullying and violence.", style: TextStyle(fontSize: 12, height: 1.3, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                SizedBox(height: 24,),
                ],
            ),
          ),
        )
    );
  }

}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../colors.dart';

class SOSScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SOSScreenState();
  }
}

class SOSScreenState extends State<SOSScreen>{
  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Help', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: themecolor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "If you are in trouble, don't hesitate to reach out immediately! You can contact the numbers below for quick help and support:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            _buildEmergencyCard(
              context,
              title: "One number for any emergency (Police, Fire, Ambulance)",
              number: "112",
              icon: Icons.emergency_rounded,
            ),
            SizedBox(height: 20),
            _buildEmergencyCard(
              context,
              title: "National Ambulance Service (NAS)",
              number: "102",
              icon: Icons.medical_services_rounded,
            ),
            SizedBox(height: 20),
            _buildEmergencyCard(
              context,
              title: "Police Control Room",
              number: "100",
              icon: Icons.local_police_rounded,
            ),
            SizedBox(height: 20),
            _buildEmergencyCard(
              context,
              title: "Student/Child Helpline",
              number: "1098",
              icon: Icons.support_agent_rounded,
            ),
            SizedBox(height: 20),
            _buildEmergencyCard(
              context,
              title: "Eve Teasing / Obscene Calls / Stalking",
              number: "1096",
              secondaryNumber: "+91 1127894455",
              icon: Icons.phone_in_talk_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context, {required String title, required String number, String? secondaryNumber, required IconData icon}) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: themecolor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themecolor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black, size: 30),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.call, color: Colors.green, size: 28),
                onPressed: () {
                  _makePhoneCall(number);
                },
              ),
            ],
          ),
          if (secondaryNumber != null) ...[
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  child: Text(
                    "Alternate: $secondaryNumber",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green, size: 28),
                  onPressed: () {
                    _makePhoneCall(secondaryNumber);
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

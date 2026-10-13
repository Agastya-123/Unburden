import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetySupportDialog {
  static const String _helplineNumber = '9152987821';

  static Future<void> show(BuildContext context) async {
    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF2E2), Color(0xFFFFE6C9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite_rounded, color: Color(0xFFF57C00), size: 28),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "You're not alone. Help is here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2B2B2B),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "It sounds like you might be going through something really difficult. You don't have to handle this on your own.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, height: 1.4, color: Color(0xFF333333)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFD79A)),
                        ),
                        child: const Text(
                          "To help support you, we're reaching out to a trusted adult who can be there for you.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, height: 1.35, color: Color(0xFF4A4A4A)),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _contactTrustedAdult(dialogContext);
                          },
                          icon: const Icon(Icons.support_agent_rounded),
                          label: const Text('Talk to someone you trust'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9B650),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await _callNumber(_helplineNumber, dialogContext);
                          },
                          icon: const Icon(Icons.call_rounded),
                          label: const Text('Call a helpline'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2B2B2B),
                            side: const BorderSide(color: Color(0xFFFFC26D), width: 1.4),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Helpline: 9152987821',
                        style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                      ),
                      const SizedBox(height: 6),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> _contactTrustedAdult(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnack(context, 'Unable to find user details.');
        return;
      }
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      final data = userDoc.data();
      final guardianPhone = (data?['guardian_contact_no'] ?? '').toString().trim();
      if (guardianPhone.isEmpty) {
        _showSnack(context, 'Trusted adult phone number not found.');
        return;
      }
      await _callNumber(guardianPhone, context);
    } catch (_) {
      _showSnack(context, 'Could not open trusted adult contact right now.');
    }
  }

  static Future<void> _callNumber(String number, BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    final bool canOpen = await canLaunchUrl(uri);
    if (!canOpen) {
      _showSnack(context, 'Could not open call app.');
      return;
    }
    await launchUrl(uri);
  }

  static void _showSnack(BuildContext context, String text) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}


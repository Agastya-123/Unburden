import 'package:flutter/material.dart';
import '../colors.dart';

/// Placeholder screen for info module articles. Set [body] when you have content.
class InfoArticleScreen extends StatelessWidget {
  const InfoArticleScreen({
    super.key,
    required this.title,
    this.body,
  });

  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themecolor,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: body != null && body!.isNotEmpty
              ? Text(
                  body!,
                  style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey.shade800),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    'Content coming soon.',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                ),
        ),
      ),
    );
  }
}

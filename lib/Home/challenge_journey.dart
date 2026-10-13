import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/colors.dart';

class ChallengeJourneyScreen extends StatelessWidget {
  const ChallengeJourneyScreen({super.key});

  static List<Map<String, dynamic>> _completionsForUser() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final box = Hive.box('challenge_completions');
    final list = <Map<String, dynamic>>[];
    for (var key in box.keys) {
      final v = box.get(key);
      if (v != null && v is Map) {
        final map = Map<String, dynamic>.from(v);
        if (map['uid'] == uid) list.add(map);
      }
    }
    list.sort((a, b) {
      final da = a['dateIso'] as String? ?? '';
      final db = b['dateIso'] as String? ?? '';
      return db.compareTo(da);
    });
    return list;
  }

  static int _currentStreak(List<Map<String, dynamic>> completions) {
    if (completions.isEmpty) return 0;
    final dates = completions.map((c) {
      final s = c['dateIso'] as String? ?? '';
      return s.length >= 10 ? s.substring(0, 10) : '';
    }).where((d) => d.isNotEmpty).toSet().toList()..sort((a, b) => b.compareTo(a));
    if (dates.isEmpty) return 0;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (dates.first != today) return 0;
    int streak = 1;
    for (int i = 1; i < dates.length; i++) {
      final prev = DateTime.parse(dates[i - 1]);
      final curr = DateTime.parse(dates[i]);
      final diff = prev.difference(curr).inDays;
      if (diff == 1) streak++; else break;
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final completions = _completionsForUser();
    final streak = _currentStreak(completions);
    final total = completions.length;

    return Scaffold(
      backgroundColor: lightThemeColor,
      appBar: AppBar(
        title: const Text("How far you've come", style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: themecolor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(total: total, streak: streak),
            const SizedBox(height: 24),
            Text(
              "Challenges you've done",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 12),
            if (completions.isEmpty)
              _buildEmptyState(context)
            else
              ...completions.map((c) => _buildCompletionTile(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({required int total, required int streak}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [themecolor.withOpacity(0.35), darkThemeColor.withOpacity(0.25)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themecolor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            "You've done $total challenge${total == 1 ? '' : 's'}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          if (streak > 1) ...[
            const SizedBox(height: 12),
            Text(
              "$streak days in a row — you showed up.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: themecolor.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text(
            "No challenges completed yet",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Spin the Daily Challenge and mark one done to see your journey here.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionTile(Map<String, dynamic> c) {
    final title = c['challengeTitle'] as String? ?? 'Challenge';
    final dateIso = c['dateIso'] as String? ?? '';
    final feel = c['feel'] as String? ?? '';
    String dateStr = '';
    try {
      if (dateIso.length >= 10) {
        final dt = DateTime.parse(dateIso.substring(0, 10));
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final challengeDay = DateTime(dt.year, dt.month, dt.day);
        final diff = today.difference(challengeDay).inDays;
        if (diff == 0) dateStr = 'Today';
        else if (diff == 1) dateStr = 'Yesterday';
        else dateStr = '${dt.day}/${dt.month}/${dt.year}';
      }
    } catch (_) {
      dateStr = dateIso;
    }
    final feelLabel = feel == 'good' ? 'Felt good' : feel == 'okay' ? 'Felt okay' : feel == 'not_great' ? 'Was hard' : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themecolor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: themecolor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.check_circle, color: themecolor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      dateStr,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    if (feelLabel.isNotEmpty) ...[
                      Text(" · ", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      Text(feelLabel, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

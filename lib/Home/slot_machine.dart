import 'dart:async';
import '/BottomNav.dart';
import '/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:roller_list/roller_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine> {
  int selectedImageIndex = 0;
  Timer? _debounceTimer;
  bool _firstCallIgnored = false;

  bool _alreadyRolledToday = false;
  int? _todayChallengeIndex;
  bool _loading = true;

  static const _lastRollDateKey = 'challenge_last_roll_date';
  static const _todayIndexKey = 'challenge_today_index';
  static const _rerollDateKey = 'challenge_reroll_date';

  bool _rerollUsedToday = false;
  static const List<String> _reflectionPrompts = [
    "One word for how this felt?",
    "What came up while doing this?",
    "Anything you want to remember from this?",
  ];

  final List<Map<String, String>> activities = [
    {'image': 'kind.png', 'title': 'Say Something Kind', 'description': 'Give one genuine compliment today.', 'whyItHelps': 'Kind words often come back to us in unexpected ways.'},
    {'image': 'remind.png', 'title': 'Remind Yourself', 'description': 'Write down 3 things you like about yourself.', 'whyItHelps': 'Your mind deserves to hear good things too.'},
    {'image': 'help.png', 'title': 'A Small Kind Act', 'description': 'Do one small helpful thing for someone.', 'whyItHelps': 'Even tiny kindness can lift your mood.'},
    {'image': 'pause.jpg', 'title': 'Pause for You', 'description': 'Spend 15 minutes doing something you enjoy.', 'whyItHelps': 'Rest is not a reward—it\'s a need.'},
    {'image': '5.jpg', 'title': 'Remember Your Strength', 'description': 'Write about a moment you felt proud of yourself.', 'whyItHelps': 'You\'ve survived more than you remember.'},
    {'image': 'check_in.png', 'title': 'Check In', 'description': 'Message or talk to a friend and truly listen.', 'whyItHelps': 'Connection eases emotional weight.'},
    {'image': 'reframe.png', 'title': 'Reframe One Moment', 'description': 'Write one hard moment and one thing it taught you.', 'whyItHelps': 'Meaning reduces emotional heaviness.'},
    {'image': 'step.png', 'title': 'One Small Step', 'description': 'Take one tiny step toward something you care about.', 'whyItHelps': 'Progress doesn\'t have to be loud.'},
    {'image': 'carry_yourself.png', 'title': 'Carry Yourself Kindly', 'description': 'Stand a little taller today.', 'whyItHelps': 'Your body can guide your emotions.'},
    {'image': 'good_things.png', 'title': 'Name Three Good Things', 'description': 'Write 3 things you\'re grateful for.', 'whyItHelps': 'Gratitude gently shifts focus.'},
    {'image': 'breathe.png', 'title': 'Breathe & Reset', 'description': 'Take 5 slow breaths right now.', 'whyItHelps': 'Your nervous system needs pauses.'},
    {'image': 'boundaries.png', 'title': 'Practice a Boundary', 'description': 'Think of one boundary you want to protect today.', 'whyItHelps': 'Self-respect builds safety.'},
    {'image': '13.jpg', 'title': 'Notice a Win', 'description': 'Acknowledge one small success today.', 'whyItHelps': 'You\'re doing more than you think.'},
    {'image': 'curiosity.png', 'title': 'Feed Curiosity', 'description': 'Learn one small thing that interests you.', 'whyItHelps': 'Curiosity reconnects you to yourself.'},
  ];

  String _todayDate() => DateTime.now().toIso8601String().substring(0, 10);

  List<Map<String, dynamic>> _completionsForUser() {
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

  int _currentStreak(List<Map<String, dynamic>> completions) {
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

  Future<void> _loadDailyState() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastRollDateKey);
    final todayIdx = prefs.getInt(_todayIndexKey);
    final rerollDate = prefs.getString(_rerollDateKey);
    final today = _todayDate();
    setState(() {
      _alreadyRolledToday = lastDate == today;
      _todayChallengeIndex = todayIdx;
      _rerollUsedToday = rerollDate == today;
      _loading = false;
    });
  }

  Future<void> _useReroll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rerollDateKey, _todayDate());
    setState(() {
      _rerollUsedToday = true;
      _alreadyRolledToday = false;
      _todayChallengeIndex = null;
    });
    await prefs.remove(_lastRollDateKey);
    await prefs.remove(_todayIndexKey);
  }

  Future<void> _saveRoll(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRollDateKey, _todayDate());
    await prefs.setInt(_todayIndexKey, index);
    setState(() {
      _alreadyRolledToday = true;
      _todayChallengeIndex = index;
    });
  }

  Future<void> _saveCompletion(int challengeIndex, String reflectionMood, String? reflectionNote) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final activity = activities[challengeIndex];
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final completion = {
      'uid': uid,
      'challengeIndex': challengeIndex,
      'challengeTitle': activity['title'] ?? '',
      'dateIso': DateTime.now().toIso8601String(),
      'feel': reflectionMood,
      'reflection_mood': reflectionMood,
      'reflection_note': reflectionNote,
    };
    await Hive.box('challenge_completions').put(id, completion);
    setState(() {});
  }

  static String _affirmationForMood(String mood) {
    switch (mood) {
      case 'lighter':
        return "I'm glad you took this moment for yourself.";
      case 'same':
        return "Showing up still counts.";
      case 'heavy':
        return "Some days are heavier. You still did something kind for yourself.";
      default:
        return "Showing up still counts.";
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDailyState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightThemeColor,
      appBar: AppBar(
        title: const Text("Daily Challenge", style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: themecolor,
        elevation: 0,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: themecolor))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(width),
                        const SizedBox(height: 20),
                        if (_alreadyRolledToday && _todayChallengeIndex != null)
                          _buildTodaysChallengeCard(_todayChallengeIndex!, width)
                        else
                          _buildRollerCard(width),
                      ],
                    ),
                  ),
                  Divider(height: 32, thickness: 1, color: themecolor.withOpacity(0.4)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "How far I've come",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: 16),
                        _buildJourneySection(width),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(double width) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [themecolor.withOpacity(0.35), darkThemeColor.withOpacity(0.25)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themecolor.withOpacity(0.6), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            _alreadyRolledToday ? "Your challenge for today" : "Spin for your challenge",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          if (_alreadyRolledToday) ...[
            const SizedBox(height: 6),
            Text(
              "You can mark it done and tell us how it felt.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTodaysChallengeCard(int index, double width) {
    final activity = activities[index];
    return Container(
      width: width,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themecolor.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: themecolor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/slot/${activity['image']!}",
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            activity['title']!,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "What to do:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            activity['description']!,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Why it helps:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            activity['whyItHelps'] ?? '',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showReflectionScreen(index),
              icon: Text("🌱", style: TextStyle(fontSize: 20)),
              label: Text("Mark as Done"),
              style: ElevatedButton.styleFrom(
                backgroundColor: themecolor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
          ),
          if (!_rerollUsedToday) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () async {
                await _useReroll();
              },
              icon: Text("🔄", style: TextStyle(fontSize: 14)),
              label: Text("Re-roll (1 free)", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRollerCard(double width) {
    final rollerWidth = (width * 0.45).clamp(140.0, 180.0);
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themecolor.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: themecolor.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            "Scroll to spin",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Center(
            child: RollerList(
              items: activities
                  .map((activity) => Container(
                        margin: EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/slot/${activity['image']!}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                  .toList(),
              dividerColor: themecolor,
              dividerThickness: 3,
              initialIndex: selectedImageIndex,
              onSelectedIndexChanged: (index) {
                if (!_firstCallIgnored) {
                  _firstCallIgnored = true;
                  return;
                }
                selectedImageIndex = index;
                _debounceTimer?.cancel();
                _debounceTimer = Timer(Duration(milliseconds: 500), () {
                  _saveRoll(index);
                  _showChallengeDialog(index);
                });
              },
              width: rollerWidth,
              height: 110,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneySection(double width) {
    final completions = _completionsForUser();
    final streak = _currentStreak(completions);
    final total = completions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: width,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
        ),
        const SizedBox(height: 16),
        if (completions.isEmpty)
          _buildJourneyEmpty()
        else
          ...completions.map((c) => _buildCompletionTile(c)),
      ],
    );
  }

  Widget _buildJourneyEmpty() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themecolor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 56, color: themecolor.withOpacity(0.6)),
          const SizedBox(height: 12),
          Text(
            "No challenges completed yet",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            "Spin above and mark one done to see your journey here.",
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
    final reflectionMood = c['reflection_mood'] as String? ?? c['feel'] as String? ?? '';
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
    String feelLabel = '';
    if (reflectionMood == 'lighter') feelLabel = 'Lighter';
    else if (reflectionMood == 'same') feelLabel = 'Same';
    else if (reflectionMood == 'heavy') feelLabel = 'Heavy but okay';
    else if (reflectionMood == 'good') feelLabel = 'Felt good';
    else if (reflectionMood == 'okay') feelLabel = 'Felt okay';
    else if (reflectionMood == 'not_great') feelLabel = 'Was hard';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themecolor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

  void _showChallengeDialog(int index) {
    final activity = activities[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: lightThemeColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Your challenge today",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/slot/${activity['image']!}",
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              activity['title']!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What to do:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                activity['description']!,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Why it helps:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                activity['whyItHelps'] ?? '',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showReflectionScreen(index);
                },
                icon: Text("🌱", style: TextStyle(fontSize: 20)),
                label: Text("Mark as Done"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themecolor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ),
            if (!_rerollUsedToday) ...[
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await _useReroll();
                },
                icon: Text("🔄", style: TextStyle(fontSize: 14)),
                label: Text("Re-roll (1 free)", style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showReflectionScreen(int index) {
    final challengeIndex = index;
    final selectedMoodHolder = ValueNotifier<String?>(null);
    final noteController = TextEditingController();
    final promptIndex = challengeIndex % _reflectionPrompts.length;
    final prompt = _reflectionPrompts[promptIndex];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ValueListenableBuilder<String?>(
        valueListenable: selectedMoodHolder,
        builder: (context, selectedMood, _) {
          return Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: lightThemeColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "How do you feel right now?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _moodChip("😌 Lighter", "lighter", selectedMood, () => selectedMoodHolder.value = "lighter"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _moodChip("😐 Same", "same", selectedMood, () => selectedMoodHolder.value = "same"),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _moodChip("😔 Heavy but okay", "heavy", selectedMood, () => selectedMoodHolder.value = "heavy"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    prompt,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "(Optional) Write a line…",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: selectedMood == null
                          ? null
                          : () async {
                              await _saveCompletion(challengeIndex, selectedMood!, noteController.text.trim().isEmpty ? null : noteController.text.trim());
                              noteController.dispose();
                              if (context.mounted) {
                                Navigator.pop(context);
                                _showAffirmation(selectedMood!);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themecolor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: Text("Done"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _moodChip(String label, String value, String? selected, VoidCallback onTap) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themecolor.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? themecolor : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
        ),
      ),
    );
  }

  void _showAffirmation(String mood) {
    final message = _affirmationForMood(mood);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: lightThemeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(fontWeight: FontWeight.w600, color: themecolor)),
          ),
        ],
      ),
    );
  }
}

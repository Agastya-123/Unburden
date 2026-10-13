import '/Journal/jentry.dart';
import '/Journal/jread.dart';
import '/colors.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Journal extends StatefulWidget {
  @override
  State createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  final user = FirebaseAuth.instance.currentUser;

  String _getEmotionEmoji(String emotion) {
    String lowerEmotion = emotion.toLowerCase();
    if (lowerEmotion.contains('happy') || lowerEmotion.contains('joy')) return '😊';
    if (lowerEmotion.contains('sad')) return '😢';
    if (lowerEmotion.contains('angry') || lowerEmotion.contains('mad')) return '😠';
    if (lowerEmotion.contains('anxious') || lowerEmotion.contains('worried')) return '😰';
    if (lowerEmotion.contains('calm') || lowerEmotion.contains('peaceful')) return '😌';
    if (lowerEmotion.contains('excited')) return '🤩';
    if (lowerEmotion.contains('tired')) return '😴';
    if (lowerEmotion.contains('confused')) return '😕';
    return '📝';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<List<Map<String, dynamic>>> _loadJournals() async {
    try {
      final journalsBox = Hive.box('journals');
      
      List<Map<String, dynamic>> journals = [];
      
      for (var key in journalsBox.keys) {
        var journal = journalsBox.get(key);
        if (journal != null && journal is Map) {
          Map<String, dynamic> journalMap = Map<String, dynamic>.from(journal);
          if (journalMap['uid'] == user?.uid) {
            journals.add(journalMap);
          }
        }
      }
      
      journals.sort((a, b) {
        String timestampA = a['timestamp'] ?? '';
        String timestampB = b['timestamp'] ?? '';
        return timestampB.compareTo(timestampA);
      });
      
      return journals;
    } catch (e) {
      print("Error loading journals: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Journal",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: themecolor,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: Container(
        width: 100,
        height: 50,
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => Jentry()));
            // Refresh the list when returning from journal entry
            setState(() {});
          },
          backgroundColor: themecolor,
          child: EasyRichText(
            "Write 📖",
            defaultStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
            patternList: const [
              EasyRichTextPattern(
                targetString: '📖',
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          // Text("Write 📖", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black),),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadJournals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No journals yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Start sharing your thoughts!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          final journals = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: journals.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final journal = journals[index];
                String content = journal['content'] ?? '';
                String emotion = journal['emotion'] ?? 'Unknown';
                String tone = journal['tone'] ?? 'Unknown';
                bool isNegative = tone.toLowerCase().contains('negative');
                
                String emotionEmoji = _getEmotionEmoji(emotion);
                
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => Jread(data: content)
                      )
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isNegative
                            ? [
                                themecolor.withOpacity(0.8),
                                themecolor.withOpacity(0.6),
                              ]
                            : [
                                themecolor.withOpacity(0.9),
                                themecolor.withOpacity(0.7),
                              ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  emotionEmoji,
                                  style: TextStyle(fontSize: 28),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    emotion.length > 8 ? emotion.substring(0, 8) : emotion,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Expanded(
                              child: Text(
                                content.length > 80
                                    ? content.substring(0, 80) + "..."
                                    : content,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    journal['timestamp'] != null
                                        ? _formatDate(DateTime.parse(journal['timestamp']))
                                        : _formatDate(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

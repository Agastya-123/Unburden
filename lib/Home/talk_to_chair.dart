import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '/colors.dart';
import '/Journal/jentry.dart';

enum _Phase { explanation, session, journalPrompt }

enum _SessionState { idle, talking, reflection, release }

class TalkToChairScreen extends StatefulWidget {
  const TalkToChairScreen({super.key});

  @override
  State<TalkToChairScreen> createState() => _TalkToChairScreenState();
}

class _TalkToChairScreenState extends State<TalkToChairScreen>
    with TickerProviderStateMixin {
  _Phase _phase = _Phase.explanation;
  _SessionState _sessionState = _SessionState.idle;
  int _timerSeconds = 90;
  Timer? _timer;
  late AnimationController _chairFadeController;
  late Animation<double> _chairFadeAnimation;

  @override
  void initState() {
    super.initState();
    _chairFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _chairFadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _chairFadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chairFadeController.dispose();
    super.dispose();
  }

  void _startTalking() {
    setState(() {
      _sessionState = _SessionState.talking;
      _timerSeconds = 90;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_timerSeconds > 0) _timerSeconds--;
      });
    });
  }

  void _imDone() {
    _timer?.cancel();
    setState(() => _sessionState = _SessionState.reflection);
  }

  void _goToRelease() {
    setState(() => _sessionState = _SessionState.release);
    _chairFadeController.forward();
  }

  void _goToJournalPrompt() {
    setState(() => _phase = _Phase.journalPrompt);
  }

  void _openJournal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Jentry()),
    ).then((_) {
      if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
    });
  }

  void _returnHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  String get _timerText {
    final m = _timerSeconds ~/ 60;
    final s = _timerSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')} remaining';
  }

  void _goFromExplanationToSession() {
    setState(() {
      _phase = _Phase.session;
      _sessionState = _SessionState.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _Phase.explanation:
        return _buildExplanationScreen();
      case _Phase.session:
        return _buildSessionScreen();
      case _Phase.journalPrompt:
        return _buildJournalPromptScreen();
    }
  }

  Widget _buildExplanationScreen() {
    return Scaffold(
      backgroundColor: lightThemeColor,
      appBar: AppBar(
        backgroundColor: themecolor,
        title: const Text(
          "Talk to the Chair",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        "What the chair is for",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "The chair is a safe space to let your feelings out.\n"
                        "It won't judge, interrupt, or remember what you say.\n"
                        "You can say anything — out loud or in your head.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      Center(
                        child: Image.asset(
                          "assets/chair.png",
                          width: 160,
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        "How it works",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Tap Start talking and take a moment to say what you feel.\n"
                        "Nothing is recorded or saved.\n"
                        "When you're done, you can simply let it go.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goFromExplanationToSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themecolor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Start talking",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionScreen() {
    if (_sessionState == _SessionState.release) {
      return Scaffold(
        backgroundColor: lightThemeColor,
        body: Stack(
          children: [
            const _FloatingParticles(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(begin: 1, end: 0.5).animate(
                        CurvedAnimation(
                          parent: _chairFadeController,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: Image.asset(
                        "assets/chair.png",
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Good job. You did well.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "You said what you needed to. It's okay to let it go now — you don't have to carry it anymore.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "If you're not ready to let it go yet, that's okay too. You can write it in your journal whenever you like.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _returnHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themecolor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Return to Home",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_sessionState == _SessionState.talking) {
      return Scaffold(
        backgroundColor: lightThemeColor,
        body: SafeArea(
          child: _buildSessionTalking(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: lightThemeColor,
      appBar: AppBar(
        backgroundColor: themecolor,
        title: const Text(
          "Talk to the Chair",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: _sessionState == _SessionState.idle
            ? _buildSessionIdle()
            : _buildSessionReflection(),
      ),
    );
  }

  Widget _buildSessionIdle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Image.asset(
              "assets/chair.png",

              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "This is your space.\nNothing here is recorded.\nSay whatever you need to.",
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startTalking,
              style: ElevatedButton.styleFrom(
                backgroundColor: themecolor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
              ),
              child: const Text(
                "Start Talking",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSessionTalking() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          const Spacer(),
          Center(
            child: Image.asset(
              "assets/chair.png",
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _imDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: themecolor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 2,
              ),
              child: const Text(
                "I'm done",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSessionReflection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                "assets/chair.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "You spoke your thoughts.\nWhat would you like to do now?",
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _goToRelease,
                icon: const Text("🌬️", style: TextStyle(fontSize: 20)),
                label: const Text("Let it go"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: themecolor,
                  side: BorderSide(color: themecolor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _goToJournalPrompt,
                icon: Icon(Icons.edit_note, color: themecolor),
                label: const Text("Write it in my journal"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: themecolor,
                  side: BorderSide(color: themecolor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: themecolor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: themecolor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, size: 20, color: themecolor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "If something is really bothering you, it can also help to talk to someone you trust.",
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalPromptScreen() {
    return Scaffold(
      backgroundColor: lightThemeColor,
      appBar: AppBar(
        backgroundColor: themecolor,
        title: const Text(
          "Talk to the Chair",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  "assets/chair.png",
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                "Would you like to write about what you just shared?",
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openJournal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themecolor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Open Journal",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingParticles extends StatefulWidget {
  const _FloatingParticles();

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 25; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: 4 + _random.nextDouble() * 6,
        duration: 3 + _random.nextDouble() * 4,
        delay: _random.nextDouble() * 2,
      ));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
            color: themecolor.withOpacity(0.4),
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double duration;
  final double delay;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.duration,
    required this.delay,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final cycle = (progress * 8 + p.delay) % (p.duration + 1);
      final t = (cycle / p.duration).clamp(0.0, 1.0);
      final y = (1 - t) * (size.height + 20) + p.y * 40;
      final x = size.width * p.x + math.sin(t * math.pi * 2) * 20;
      final opacity = (1 - t) * 0.6;
      canvas.drawCircle(
        Offset(x, y),
        p.size,
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

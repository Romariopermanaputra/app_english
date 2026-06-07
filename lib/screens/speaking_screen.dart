import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import '../data/question_data.dart';
import '../utils/progress_manager.dart'; // ✅ Import ProgressManager
import '../utils/score_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/audio_manager.dart';
import '../widgets/kid_friendly_background.dart';
import 'practice_result_screen.dart';

class SpeakingScreen extends StatefulWidget {
  final int chapter;
  final int classNumber;

  const SpeakingScreen({super.key, this.chapter = 1, this.classNumber = 4});

  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen>
    with SingleTickerProviderStateMixin {
  // ─── Speech to Text ───────────────────────────────────────────────────────
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;
  String _recognizedText = ''; // teks final setelah selesai bicara
  String _liveText = ''; // teks sementara SAAT user sedang bicara

  // ─── Quiz state ───────────────────────────────────────────────────────────
  int _index = 0;
  int _score = 0;
  String _feedback = ''; // 'correct' | 'wrong' | ''
  bool _answered = false;
  bool _hasFailedCurrentQuestion = false;

  // ─── Pulse animation ──────────────────────────────────────────────────────
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // ─── Session tracking ─────────────────────────────────────────────────────
  int _listenSessionId = 0;

  // ─── Daftar soal ──────────────────────────────────────────────────────────
  late final List<Map<String, String>> _questions;

  // ─── Init ─────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _questions = QuestionData.speaking(widget.classNumber, widget.chapter);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _initSpeech();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _speech.stop();
    super.dispose();
  }

  // ─── Inisialisasi Speech ───────────────────────────────────────────────────
  Future<void> _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        debugLogging: true,
        onError: (error) {
          debugPrint(
            '❌ Speech error: ${error.errorMsg} | permanent: ${error.permanent}',
          );
          if (mounted) {
            setState(() => _isListening = false);
            _pulseController
              ..stop()
              ..reset();
            if (error.permanent) _initSpeech();
          }
        },
        onStatus: (status) {
          debugPrint('🔊 Status: $status');
          if (status == stt.SpeechToText.doneStatus ||
              status == stt.SpeechToText.notListeningStatus) {
            if (mounted) {
              setState(() => _isListening = false);
              _pulseController
                ..stop()
                ..reset();
            }
          }
        },
      );

      debugPrint(
        _speechAvailable
            ? '✅ Speech recognition siap'
            : '⚠️ Speech recognition tidak tersedia',
      );

      if (!_speechAvailable && mounted) {
        _showSnackbar('⚠️ Speech recognition tidak tersedia di perangkat ini');
      }

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('❌ Init error: $e');
    }
  }

  // ─── Mulai Rekam ──────────────────────────────────────────────────────────
  Future<void> _startListening() async {
    AudioManager().playSfx('click.wav');
    if (!_speechAvailable || _answered || _isListening) return;

    setState(() {
      _liveText = '';
      _recognizedText = '';
      _feedback = '';
      _isListening = true;
    });

    _listenSessionId++;
    final int currentSession = _listenSessionId;

    _pulseController.repeat(reverse: true);

    final locales = await _speech.locales();
    String? selectedLocale;
    for (final locale in locales) {
      if (locale.localeId.startsWith('en')) {
        selectedLocale = locale.localeId;
        break;
      }
    }
    debugPrint('🌐 Locale dipilih: $selectedLocale ?? default');

    await _speech.listen(
      onResult: (result) {
        if (_listenSessionId != currentSession) return;
        _onSpeechResult(result);
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      localeId: selectedLocale,
      partialResults: true,
      cancelOnError: false,
      listenMode: stt.ListenMode.confirmation,
      onSoundLevelChange: (level) {
        debugPrint('🎙️ Sound level: $level');
      },
    );
  }

  // ─── Callback hasil speech ───────────────────────────────────────────────
  void _onSpeechResult(SpeechRecognitionResult result) {
    debugPrint(
      '📝 Words: "${result.recognizedWords}" | final: ${result.finalResult}',
    );
    if (!mounted) return;

    setState(() {
      if (result.finalResult) {
        _recognizedText = result.recognizedWords.toLowerCase().trim();
        _liveText = '';
        _isListening = false;
        _pulseController
          ..stop()
          ..reset();
        _checkAnswer();
      } else {
        _liveText = result.recognizedWords;
      }
    });
  }

  // ─── Stop Rekam Manual ────────────────────────────────────────────────────
  Future<void> _stopListening() async {
    AudioManager().playSfx('click.wav');
    await _speech.stop();
    _pulseController
      ..stop()
      ..reset();

    if (mounted) {
      setState(() {
        _isListening = false;
        if (_liveText.isNotEmpty) {
          _recognizedText = _liveText.toLowerCase().trim();
          _liveText = '';
        }
      });

      if (_recognizedText.isNotEmpty && !_answered) {
        _checkAnswer();
      }
    }
  }

  // ─── Cek Jawaban ──────────────────────────────────────────────────────────
  void _checkAnswer() {
    if (_answered) return;

    String cleanString(String text) {
      return text.toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '') // hapus tanda baca
          .trim()
          .replaceAll(RegExp(r'\s+'), ' '); // hapus spasi berlebih
    }

    final expected = cleanString(_questions[_index]['q']!);
    final recognized = cleanString(_recognizedText);

    final isCorrect =
        recognized == expected ||
        (recognized.isNotEmpty && recognized.contains(expected)) ||
        (recognized.isNotEmpty && expected.contains(recognized));

    debugPrint('✅ Expected  : "$expected"');
    debugPrint('🗣️ Recognized: "$recognized"');
    debugPrint('📊 Correct   : $isCorrect');

    setState(() {
      _answered = true;
      _feedback = isCorrect ? 'correct' : 'wrong';
      if (isCorrect) {
        if (!_hasFailedCurrentQuestion) {
          _score += 10;
        }
      } else {
        _hasFailedCurrentQuestion = true;
      }
    });
  }

  // ─── Next Question ────────────────────────────────────────────────────────
  void _next() {
    AudioManager().playSfx('click.wav');
    _speech.cancel();
    _listenSessionId++;
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _feedback = '';
        _answered = false;
        _recognizedText = '';
        _liveText = '';
        _hasFailedCurrentQuestion = false;
      });
    } else {
      _showResultDialog();
    }
  }

  // ─── Retry Question ───────────────────────────────────────────────────────
  void _retry() {
    AudioManager().playSfx('click.wav');
    _speech.cancel();
    _listenSessionId++;
    setState(() {
      _feedback = '';
      _answered = false;
      _recognizedText = '';
      _liveText = '';
    });
  }

  // ─── Dialog Hasil Akhir ───────────────────────────────────────────────────
  // ✅ UPDATED: Menambahkan ProgressManager.completeLevel(3)
  void _showResultDialog() async {
    final total = _questions.length * 10;

    ScoreService().saveScore(
      module: 'speaking',
      classNumber: widget.classNumber,
      level: 3,
      score: _score,
      maxScore: total,
    );

    // 🎯 Simpan progress: Level 3 selesai
    await ProgressManager.completeLevel(widget.classNumber, 3);
    debugPrint('✅ Speaking Level completed! Progress saved.');

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PracticeResultScreen(
            score: _score,
            totalQuestions: _questions.length,
            classNumber: widget.classNumber,
            levelType: 'speaking',
            level: widget.chapter,
          ),
        ),
      );
    }
  }

  // ─── Snackbar Helper ──────────────────────────────────────────────────────
  void _showSnackbar(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  // ─── UI ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final q = _questions[_index];
    final isLastQuestion = _index == _questions.length - 1;

    final displayText = _isListening && _liveText.isNotEmpty
        ? _liveText
        : _recognizedText;
    final isDisplayingLive = _isListening && _liveText.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          '🎤 Speaking Practice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Score: $_score',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: KidFriendlyBackground(
        baseColor: Colors.orange,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              // ── Progress bar ──────────────────────────────────────────────
              Row(
                children: List.generate(_questions.length, (i) {
                  final color = i < _index
                      ? Colors.green
                      : i == _index
                      ? Colors.orange
                      : Colors.grey.shade300;
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                'Soal ${_index + 1} dari ${_questions.length}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),

              const SizedBox(height: 36),

              // ── Kartu soal ────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 36,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.orange.shade200, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2),
                      blurRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Ucapkan kata berikut:',
                      style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      q['q']!,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF8C00),
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Tombol Mic ────────────────────────────────────────────────
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _isListening ? _pulseAnimation.value : 1.0,
                    child: child,
                  ),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: _isListening
                          ? Colors.red
                          : _answered
                          ? Colors.grey.shade400
                          : Colors.orange.shade700,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : Colors.orange)
                              .withOpacity(0.4),
                          blurRadius: _isListening ? 24 : 12,
                          spreadRadius: _isListening ? 6 : 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isListening
                    ? 'Sedang mendengarkan... (tap untuk stop)'
                    : _answered
                    ? 'Sudah dijawab'
                    : _speechAvailable
                    ? 'Tap lalu ucapkan kata di atas'
                    : 'Memuat speech recognition...',
                style: TextStyle(
                  color: _isListening ? Colors.red : Colors.grey.shade600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // ── Kotak transkripsi LIVE ─────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 58),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isDisplayingLive
                      ? Colors.blue.shade50
                      : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDisplayingLive
                        ? Colors.blue.shade300
                        : Colors.grey.shade300,
                    width: isDisplayingLive ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      isDisplayingLive ? Icons.graphic_eq : Icons.hearing,
                      size: 20,
                      color: isDisplayingLive ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        displayText.isEmpty
                            ? _isListening
                                  ? 'Bicara sekarang...'
                                  : 'Hasil ucapan kamu akan muncul di sini'
                            : '"$displayText"',
                        style: TextStyle(
                          fontSize: 15,
                          color: displayText.isEmpty
                              ? Colors.grey.shade400
                              : Colors.black87,
                          fontStyle: isDisplayingLive
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                    if (isDisplayingLive) const _DotsIndicator(),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Feedback benar / salah ─────────────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _feedback.isEmpty
                    ? const SizedBox(key: ValueKey('empty'), height: 56)
                    : Container(
                        key: ValueKey(_feedback),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: _feedback == 'correct'
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _feedback == 'correct'
                                ? Colors.green.shade400
                                : Colors.red.shade400,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_feedback == 'correct' ? Colors.green : Colors.red).withOpacity(0.2),
                              blurRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _feedback == 'correct'
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: _feedback == 'correct'
                                  ? Colors.green
                                  : Colors.red,
                              size: 26,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _feedback == 'correct'
                                        ? 'Benar! +10 poin 🎉'
                                        : 'Kurang tepat, coba lagi!',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: _feedback == 'correct'
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                    ),
                                  ),
                                  if (_feedback == 'wrong')
                                    Text(
                                      'Yang benar: "${_questions[_index]['q']}"',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red.shade400,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const Spacer(),

              // ── Tombol Next / Retry ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _answered
                      ? (_feedback == 'wrong' ? _retry : _next)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _feedback == 'wrong' ? Colors.red.shade500 : Colors.orange.shade500,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                        color: _answered 
                            ? (_feedback == 'wrong' ? Colors.red.shade700 : Colors.orange.shade700) 
                            : Colors.transparent, 
                        width: 3
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _feedback == 'wrong'
                        ? 'Coba Lagi 🔄'
                        : (isLastQuestion ? 'Lihat Hasil 🏆' : 'Soal Berikutnya →'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (_answered && _feedback == 'wrong') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLastQuestion ? 'Lihat Hasil 🏆' : 'Lanjut →',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      ),
    );
  }
}

// ─── Widget animasi titik (...) saat live recording ───────────────────────────
class _DotsIndicator extends StatefulWidget {
  const _DotsIndicator();

  @override
  State<_DotsIndicator> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<_DotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 600),
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _dotCount = (_ctrl.value * 3).ceil().clamp(1, 3));
            }
          })
          ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '.' * _dotCount,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const EnglishSpeakingApp());
}

class EnglishSpeakingApp extends StatelessWidget {
  const EnglishSpeakingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'English Speaking Practice',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SpeakingPracticeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SpeakingPracticeScreen extends StatefulWidget {
  const SpeakingPracticeScreen({super.key});

  @override
  State<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen> {
  final List<Map<String, String>> _questions = [
    {'question': 'Say: "Hello, how are you?"', 'answer': 'hello how are you'},
    {'question': 'Say: "My name is John"', 'answer': 'my name is john'},
    {'question': 'Say: "I love learning English"', 'answer': 'i love learning english'},
    {'question': 'Say: "Thank you very much"', 'answer': 'thank you very much'},
  ];

  late SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';
  String _feedback = '';
  Color _feedbackColor = Colors.transparent;
  int _currentIndex = 0;
  int _score = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _initSpeech();
  }

  // 🔹 Inisialisasi speech recognition + request permission
  Future<void> _initSpeech() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      // Initialize speech-to-text
      final available = await _speech.initialize(
        onError: (error) => print('Speech error: $error'),
        onStatus: (status) => print('Speech status: $status'),
      );
      setState(() => _isInitialized = available);
    } else {
      setState(() => _isInitialized = false);
    }
  }

  // 🔹 Start listening
  void _startListening() {
    setState(() {
      _recognizedText = '';
      _feedback = '';
      _feedbackColor = Colors.transparent;
      _isListening = true;
    });
    
    _speech.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      },
      localeId: 'en_US', // ✅ English (US)
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  // 🔹 Stop listening + check answer
  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    if (_recognizedText.isNotEmpty) {
      _checkAnswer();
    }
  }

  // 🔹 Validate answer
  void _checkAnswer() {
    final currentAnswer = _questions[_currentIndex]['answer']!.toLowerCase().trim();
    final userSpeech = _recognizedText.toLowerCase().trim();
    
    // Clean: remove punctuation & extra spaces
    final cleanUser = userSpeech.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(RegExp(r'\s+'), ' ');
    final cleanAnswer = currentAnswer.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(RegExp(r'\s+'), ' ');
    
    setState(() {
      if (cleanUser == cleanAnswer) {
        _feedback = '✅ Correct! Great job! 🎉';
        _feedbackColor = Colors.green;
        _score += 10;
      } else {
        _feedback = '❌ Try again!\nExpected: "$currentAnswer"';
        _feedbackColor = Colors.red;
      }
    });
  }

  // 🔹 Next question
  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _recognizedText = '';
        _feedback = '';
        _feedbackColor = Colors.transparent;
      });
    } else {
      _showResultDialog();
    }
  }

  // 🔹 Result dialog
  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Practice Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your Score: $_score / ${_questions.length * 10}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Want to practice again?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _recognizedText = '';
                _feedback = '';
              });
            },
            child: const Text('Restart'),
          ),
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🗣️ English Speaking Practice'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: !_isInitialized
          ? _buildInitUI()
          : _buildPracticeUI(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Question ${_currentIndex + 1}/${_questions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Score: $_score',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  // 🔹 UI saat inisialisasi / permission denied
  Widget _buildInitUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic_off, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            Text(
              _isInitialized 
                  ? 'Loading...' 
                  : '🎤 Microphone Permission Required',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Please allow microphone access to practice speaking.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initSpeech,
              child: const Text('Retry Permission'),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 UI utama latihan speaking
  Widget _buildPracticeUI() {
    final currentQuestion = _questions[_currentIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.psychology, size: 40, color: Colors.blue),
                  const SizedBox(height: 15),
                  Text(
                    currentQuestion['question']!,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // 🎤 Tombol mikrofon
          GestureDetector(
            onTap: _isListening ? _stopListening : _startListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? Colors.red : Colors.green,
                boxShadow: _isListening
                    ? [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)]
                    : [],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: 10),
          Text(
            _isListening ? '🔊 Listening...' : 'Tap to speak',
            style: TextStyle(
              color: _isListening ? Colors.red : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 25),
          
          // 📝 Hasil transkripsi
          if (_recognizedText.isNotEmpty)
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text('🗣️ You said:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('"$_recognizedText"',
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 20),
          
          // ✅❌ Feedback
          if (_feedback.isNotEmpty)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _feedbackColor.withOpacity(0.1),
                border: Border.all(color: _feedbackColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _feedback,
                style: TextStyle(
                  color: _feedbackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          const SizedBox(height: 30),
          
          // ➡️ Tombol Next
          if (_feedback.isNotEmpty)
            ElevatedButton.icon(
              onPressed: _nextQuestion,
              icon: const Icon(Icons.arrow_forward),
              label: Text(_currentIndex < _questions.length - 1 
                  ? 'Next Question' : 'See Results'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
        ],
      ),
    );
  }
}
// File: lib/data/chapter1_questions.dart

import '../models/chapter1_question.dart';

final List<Chapter1Question> chapter1Questions = [
  // I SPY! - Listen & Match (Worksheet 1.1)
  Chapter1Question(
    id: 'ch1_ws1_1',
    type: QuestionType.matching,
    title: 'I Spy! - Match & Speak',
    instruction: 'Cocokkan kata dengan aktivitas pagi yang benar.',
    question: 'Pilih pasangan yang tepat:',
    options: [
      'get up',
      'take a shower',
      'make the bed',
      'have breakfast',
      'go to school',
    ],
    correctAnswers: [
      'get up',
      'take a shower',
      'make the bed',
      'have breakfast',
      'go to school',
    ],
    explanation: 'Kata kunci Unit 1: rutinitas pagi di rumah.',
    audioRef: 'k4audio1.1',
  ),

  // STORY TIME - Order (Worksheet 1.2)
  Chapter1Question(
    id: 'ch1_ws1_2',
    type: QuestionType.ordering,
    title: 'Story Time - Order the Routine',
    instruction: 'Urutkan kegiatan Pipit berdasarkan Comic Strip 1.1',
    question: 'Atur urutan dari 1 sampai 5:',
    options: [
      'Pipit gets up',
      'Pipit takes a shower',
      'Pipit makes the bed',
      'Pipit has breakfast',
      'Pipit goes to school',
    ],
    correctAnswers: [
      'Pipit gets up',
      'Pipit takes a shower',
      'Pipit makes the bed',
      'Pipit has breakfast',
      'Pipit goes to school',
    ],
    explanation: 'Urutan sesuai alur cerita Pipit dan Emak.',
    audioRef: 'k4audio1.5',
  ),

  // TIME FOR SCHOOL - Comprehension (Worksheet 1.5)
  Chapter1Question(
    id: 'ch1_ws1_5',
    type: QuestionType.multipleChoice,
    title: 'Time for School - Story Comprehension',
    instruction: 'Jawab berdasarkan dialog Bara dan Papa.',
    question: 'What time does Bara usually get up?',
    options: ['05:00', '05:30', '06:15', '06:45'],
    correctAnswers: ['05:30'],
    explanation: 'Papa: "You usually get up at 05:30." (Comic Strip 1.2)',
    audioRef: 'k4audio1.8',
  ),

  // MY TURN - Fill Blank (Worksheet 1.7)
  Chapter1Question(
    id: 'ch1_ws1_7',
    type: QuestionType.fillBlank,
    title: 'My Turn - Complete the Text',
    instruction: 'Lengkapi kalimat dengan waktu yang tepat.',
    question: 'I get up at ____ in the morning.',
    options: [
      'five o\'clock',
      'five-fifteen',
      'five-thirty',
      'five forty-five',
    ],
    correctAnswers: ['five-thirty'],
    explanation: 'Latihan telling time untuk rutinitas pribadi.',
  ),

  // TIME MATCHING (Worksheet 1.4)
  Chapter1Question(
    id: 'ch1_ws1_4',
    type: QuestionType.matching,
    title: 'Time for School - Match the Clock',
    instruction: 'Cocokkan jam digital dengan ucapannya.',
    question: 'Pilih pasangan waktu yang benar:',
    options: ['05:00', '05:15', '05:30', '05:45'],
    correctAnswers: [
      'five o\'clock',
      'five-fifteen',
      'five-thirty',
      'five forty-five',
    ],
    explanation: 'Fokus Unit 2: telling time dengan quarter past/half.',
    audioRef: 'k4audio1.6',
  ),
];

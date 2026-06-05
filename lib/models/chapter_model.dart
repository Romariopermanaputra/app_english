// File: lib/models/chapter_model.dart

enum ChapterStatus { locked, available, completed }

class Chapter {
  final int id;
  final String title;
  final String description;
  final String backgroundImage;
  final List<Unit> units;
  final ChapterStatus status;
  final int requiredStars;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.backgroundImage,
    required this.units,
    this.status = ChapterStatus.locked,
    this.requiredStars = 3,
  });

  bool get isUnlocked => status != ChapterStatus.locked;
  int get totalUnits => units.length;
  int get completedUnits => units.where((u) => u.isCompleted).length;
}

class Unit {
  final String id;
  final String title;
  final String icon;
  final List<Lesson> lessons;
  bool isCompleted;

  Unit({
    required this.id,
    required this.title,
    required this.icon,
    required this.lessons,
    this.isCompleted = false,
  });
}

class Lesson {
  final String id;
  final String title;
  final LessonType type;
  final String? audioRef;
  bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    this.audioRef,
    this.isCompleted = false,
  });
}

enum LessonType { iSpy, song, story, game, myTurn, quiz }

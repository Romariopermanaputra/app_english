// File: lib/data/chapters_data.dart

import '../models/chapter_model.dart';

final List<Chapter> allChapters = [
  // CHAPTER 1: My Morning Routine
  Chapter(
    id: 1,
    title: 'My Morning Routine',
    description: 'Learn about daily morning activities and telling time',
    backgroundImage: 'assets/images/chapter1_bg.png',
    requiredStars: 3,
    units: [
      Unit(
        id: 'ch1_unit1',
        title: 'Get Up!',
        icon: '🌅',
        lessons: [
          Lesson(
            id: 'ch1_u1_1',
            title: 'I Spy!',
            type: LessonType.iSpy,
            audioRef: 'k4audio1.1',
          ),
          Lesson(
            id: 'ch1_u1_2',
            title: 'Song Time',
            type: LessonType.song,
            audioRef: 'k4audio1.4',
          ),
          Lesson(
            id: 'ch1_u1_3',
            title: 'Story Time',
            type: LessonType.story,
            audioRef: 'k4audio1.5',
          ),
          Lesson(id: 'ch1_u1_4', title: 'Game Time', type: LessonType.game),
          Lesson(id: 'ch1_u1_5', title: 'My Turn', type: LessonType.myTurn),
        ],
      ),
      Unit(
        id: 'ch1_unit2',
        title: 'Time for School',
        icon: '⏰',
        lessons: [
          Lesson(
            id: 'ch1_u2_1',
            title: 'I Spy!',
            type: LessonType.iSpy,
            audioRef: 'k4audio1.6',
          ),
          Lesson(
            id: 'ch1_u2_2',
            title: 'Story Time',
            type: LessonType.story,
            audioRef: 'k4audio1.8',
          ),
          Lesson(id: 'ch1_u2_3', title: 'Game Time', type: LessonType.game),
          Lesson(id: 'ch1_u2_4', title: 'My Turn', type: LessonType.myTurn),
        ],
      ),
    ],
  ),

  // CHAPTER 2: Meal Time
  Chapter(
    id: 2,
    title: 'Meal Time',
    description: 'Learn about food, taste, and meal times',
    backgroundImage: 'assets/images/chapter2_bg.png',
    requiredStars: 6,
    units: [],
  ),

  // CHAPTER 3: My Toys
  Chapter(
    id: 3,
    title: 'My Toys',
    description: 'Learn about toys, shapes, and colors',
    backgroundImage: 'assets/images/chapter3_bg.png',
    requiredStars: 9,
    units: [],
  ),

  // CHAPTER 4: My School Activities
  Chapter(
    id: 4,
    title: 'My School Activities',
    description: 'Learn about activities and places at school',
    backgroundImage: 'assets/images/chapter4_bg.png',
    requiredStars: 12,
    units: [],
  ),

  // CHAPTER 5: My PE Class
  Chapter(
    id: 5,
    title: 'My PE Class',
    description: 'Learn about sports and feelings',
    backgroundImage: 'assets/images/chapter5_bg.png',
    requiredStars: 15,
    units: [],
  ),

  // CHAPTER 6: My School Days
  Chapter(
    id: 6,
    title: 'My School Days',
    description: 'Learn about days, months, and schedules',
    backgroundImage: 'assets/images/chapter6_bg.png',
    requiredStars: 18,
    units: [],
  ),
];

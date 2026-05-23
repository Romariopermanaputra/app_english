import 'question_data_class4.dart';
import 'question_data_class5.dart';
import 'question_data_class6.dart';

/// Factory class untuk memilih data soal berdasarkan classNumber
/// Gunakan class ini di screens untuk mendapatkan soal sesuai kelas
class QuestionData {
  /// Ambil reading passages berdasarkan kelas dan chapter
  static String readingText(int classNumber, int chapter) {
    switch (classNumber) {
      case 4:
        return QuestionDataClass4.readingText(chapter);
      case 5:
        return QuestionDataClass5.readingText(chapter);
      case 6:
        return QuestionDataClass6.readingText(chapter);
      default:
        return QuestionDataClass4.readingText(chapter);
    }
  }

  /// Ambil reading questions berdasarkan kelas dan chapter
  static List<Map<String, dynamic>> reading(int classNumber, int chapter) {
    switch (classNumber) {
      case 4:
        return QuestionDataClass4.reading(chapter);
      case 5:
        return QuestionDataClass5.reading(chapter);
      case 6:
        return QuestionDataClass6.reading(chapter);
      default:
        return QuestionDataClass4.reading(chapter);
    }
  }

  /// Ambil writing questions berdasarkan kelas dan chapter
  static List<Map<String, String>> writing(int classNumber, int chapter) {
    switch (classNumber) {
      case 4:
        return QuestionDataClass4.writing(chapter);
      case 5:
        return QuestionDataClass5.writing(chapter);
      case 6:
        return QuestionDataClass6.writing(chapter);
      default:
        return QuestionDataClass4.writing(chapter);
    }
  }

  /// Ambil speaking questions berdasarkan kelas dan chapter
  static List<Map<String, String>> speaking(int classNumber, int chapter) {
    switch (classNumber) {
      case 4:
        return QuestionDataClass4.speaking(chapter);
      case 5:
        return QuestionDataClass5.speaking(chapter);
      case 6:
        return QuestionDataClass6.speaking(chapter);
      default:
        return QuestionDataClass4.speaking(chapter);
    }
  }
}

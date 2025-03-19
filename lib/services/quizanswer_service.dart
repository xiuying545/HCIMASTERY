import 'package:cloud_firestore/cloud_firestore.dart';


class QuizAnswerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  /// ✅ Save or Update Multiple Quiz Answers at Once
  Future<void> saveMultipleQuizAnswers(String userID, String chapterID, Map<String, dynamic> quizAnswers) async {
    try {
      // // Add timestamp and merge the new answers
      // quizAnswers['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('QuizAnswer')
          .doc(userID)
          .collection('Chapters')
          .doc(chapterID)
          .set(quizAnswers, SetOptions(merge: true)); 
print("hey:: $quizAnswers");
      print('Multiple quiz answers saved successfully.');
    } catch (e) {
      print('Error saving multiple quiz answers: $e');
    }
  }

  /// ✅ Get a Single Quiz Answer
  Future<int?> getQuizAnswer(String userID, String chapterID, String quizID) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('QuizAnswer')
          .doc(userID)
          .collection('Chapters')
          .doc(chapterID)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        return data[quizID] as int?;
      } else {
        print('Quiz answer not found.');
        return null;
      }
    } catch (e) {
      print('Error retrieving quiz answer: $e');
      return null;
    }
  }

  /// ✅ Get All Answers in a Chapter
  Future<Map<String, int>> getChapterAnswers(String userID, String chapterID) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('QuizAnswer')
          .doc(userID)
          .collection('Chapters')
          .doc(chapterID)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        data.remove('updatedAt'); // Remove timestamp if exists
        return data.map((key, value) => MapEntry(key, value as int));
      } else {
        print('No answers found for this chapter.');
        return {};
      }
    } catch (e) {
      print('Error retrieving chapter answers: $e');
      return {};
    }
  }


// Future<double> calculateScore(String chapter, String userId) async {
//   QuizService quizService = QuizService();
//   List<Quiz> quizzes = await quizService.getQuizzesByChapter(chapter);
//   int correctAnswers = 0;

//   for (int i = 0; i < quizzes.length; i++) {
  
//     if (quizzes[i].quizzID != null) { 
//       String quizid = quizzes[i].quizzID!;
//       int? userAnswer = await getUserAnswer(userId, chapter, quizid); 
     
//       if (userAnswer != null && quizzes[i].answer == userAnswer) {
//         correctAnswers++;

//       }
//     }
//   }

//   return (correctAnswers/quizzes.length)*100; 
// }





}

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAnswerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Save or Update Multiple Quiz Answers at Once
  Future<void> saveMultipleQuizAnswers(
      String userID, String chapterID, Map<String, dynamic> quizAnswers) async {
    try {
      // // Add timestamp and merge the new answers
      // quizAnswers['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('QuizAnswer')
          .doc(userID)
          .collection('Chapters')
          .doc(chapterID)
          .set(quizAnswers, SetOptions(merge: true));
      await _firestore.collection('QuizAnswer').doc(userID).set(
          {'lastUpdated': FieldValue.serverTimestamp()},
          SetOptions(merge: true));
      print('Multiple quiz answers saved successfully.');
    } catch (e) {
      print('Error saving multiple quiz answers: $e');
    }
  }

  /// ✅ Get a Single Quiz Answer
  Future<int?> getQuizAnswer(
      String userID, String chapterID, String quizID) async {
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
  Future<Map<String, int>> getChapterAnswers(
      String userID, String chapterID) async {
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

  Future<void> deleteAllAnswersForUser(String userID) async {
    try {
      final chapterDocs = await _firestore
          .collection('QuizAnswer')
          .doc(userID)
          .collection('Chapters')
          .get();

      for (var doc in chapterDocs.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection('QuizAnswer').doc(userID).delete();

      print('Deleted all quiz answers for user $userID.');
    } catch (e) {
      print('Error deleting all quiz answers for user: $e');
    }
  }

  Future<void> deleteQuizAnswerForQuiz(String chapterID, String quizID) async {
    try {
      final usersSnapshot = await _firestore.collection('QuizAnswer').get();
      print("Total students found: ${usersSnapshot.docs.length}");
      for (var userDoc in usersSnapshot.docs) {
        final chapterRef = _firestore
            .collection('QuizAnswer')
            .doc(userDoc.id)
            .collection('Chapters')
            .doc(chapterID);

        final chapterDoc = await chapterRef.get();

        if (chapterDoc.exists) {
          final data = chapterDoc.data() as Map<String, dynamic>;

          if (data.containsKey(quizID)) {
            await chapterRef.update({
              quizID: FieldValue.delete(),
            });
          }
        }
      }

      print(
          'Deleted quiz answer $quizID from chapter $chapterID for all users.');
    } catch (e) {
      print('Error deleting quiz answer for quiz: $e');
    }
  }

  Future<void> deleteQuizAnswersForChapter(String chapterID) async {
    try {
      final usersSnapshot = await _firestore.collection('QuizAnswer').get();

      for (var userDoc in usersSnapshot.docs) {
        final chapterRef = _firestore
            .collection('QuizAnswer')
            .doc(userDoc.id)
            .collection('Chapters')
            .doc(chapterID);

        final chapterDoc = await chapterRef.get();
        if (chapterDoc.exists) {
          await chapterRef.delete();
        }
      }

      print('Deleted quiz answers for chapter $chapterID across all users.');
    } catch (e) {
      print('Error deleting quiz answers for chapter: $e');
    }
  }
}

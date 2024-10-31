import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/model/quizanswer.dart';
import 'package:fyp1/services/quiz_service.dart';

class QuizAnswerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<void> saveAnswer(QuizAnswer quizAnswer) async {
    
    final existingAnswerSnapshot = await _firestore
        .collection('quizAnswers')
        .where('userID', isEqualTo: quizAnswer.userID)
        .where('chapter', isEqualTo: quizAnswer.chapter)
        .get();

    if (existingAnswerSnapshot.docs.isNotEmpty) {
   
      var existingAnswerDoc = existingAnswerSnapshot.docs.first;
      var existingAnswer = existingAnswerDoc.data();


      List<String> quizzIDs = List<String>.from(existingAnswer['quizzID']);
      List<int> studentAnswers = List<int>.from(existingAnswer['studentAnswer']);


      int quizIndex = quizzIDs.indexOf(quizAnswer.quizzID.first); // Assuming quizID is a list

      if (quizIndex != -1) {
   
        studentAnswers[quizIndex] = quizAnswer.studentAnswer.first; // Assuming studentAnswer is a list
      } else {
   
        quizzIDs.add(quizAnswer.quizzID.first);
        studentAnswers.add(quizAnswer.studentAnswer.first);
      }

      await _firestore.collection('quizAnswers').doc(existingAnswerDoc.id).update({
        'quizzID': quizzIDs,
        'studentAnswer': studentAnswers,
      });
    } else {
   
      await _firestore.collection('quizAnswers').add(quizAnswer.toJson());
    }
  }

Future<int?> getUserAnswer(int userID, int chapter, String quizID) async {
  final snapshot = await _firestore
      .collection('quizAnswers')
      .where('userID', isEqualTo: userID)
      .where('chapter', isEqualTo: chapter)
      .get();


  if (snapshot.docs.isNotEmpty) {
    var data = snapshot.docs.first.data();
    var quizzIDs = List<String>.from(data['quizzID']);
    var studentAnswers = List<int>.from(data['studentAnswer']);

 
    int quizIndex = quizzIDs.indexOf(quizID);
    if (quizIndex != -1) {

      return studentAnswers[quizIndex];
    }
  }

  
  return null;
}


Future<double> calculateScore(int chapter) async {
  QuizService quizService = QuizService();
  List<Quiz> quizzes = await quizService.getQuizzesByChapter(chapter);
  int correctAnswers = 0;

  for (int i = 0; i < quizzes.length; i++) {
  
    if (quizzes[i].quizzID != null) { 
      String quizid = quizzes[i].quizzID!;
      int? userAnswer = await getUserAnswer(1, chapter, quizid); 
     
      if (userAnswer != null && quizzes[i].answer == userAnswer) {
        correctAnswers++;

      }
    }
  }

  return (correctAnswers/quizzes.length)*100; 
}


}

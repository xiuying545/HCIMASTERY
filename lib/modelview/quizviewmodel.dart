// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fyp1/model/quizanswer.dart';
import 'package:fyp1/services/quiz_service.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/services/quizanswer_service.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  final QuizAnswerService quizAnswerService = QuizAnswerService();

  List<Quiz> _quizzes = [];
  Quiz _selectedQuiz;
  double _score = 0.0;



  List<Quiz> get quizzes {
  

    
    return _quizzes;
  }

  Quiz get selectedQuiz => _selectedQuiz;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double get score {

   
    return _score;
  }

  QuizViewModel()
      : _selectedQuiz = Quiz(chapter: "", question: '', options: [], answer: 0);

  Future<void> fetchQuizzes(String chapter) async {
    _isLoading = true;
    notifyListeners();

    _quizzes = await _quizService.getQuizzesByChapter(chapter);
 
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getQuizById(String quizId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedQuiz = await _quizService.getQuizzById(quizId);
    } catch (e) {
      print('Error fetching quiz: $e');
      // Handle the error as needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveAnswer(
      String userID, String chapter, String quizId, int studentAnswer) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuizAnswer quizAnswer = QuizAnswer(
        userID: userID,
        chapter: chapter,
        quizzID: [quizId],
        studentAnswer: [studentAnswer],
      );

      await quizAnswerService.saveAnswer(quizAnswer);
      print('Answer saved successfully');
    } catch (e) {
      print('Error saving answer: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getUserAnswer(String userID, String chapter, String quizID) async {
    _isLoading = true;
    notifyListeners();

    try {
      int? answer =
          await quizAnswerService.getUserAnswer(userID, chapter, quizID);
      print('Answer retrieved: $answer');
      if (answer != null) {
        return answer;
      } else {
        return 5; // This will return a single answer
      }
    } catch (e) {
      print('Error retrieving answer: $e');
      return 5; // Return null in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<double> calculateScore(String chapter,userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _score = await quizAnswerService.calculateScore(chapter,userId);

      print('Score calculated: $_score');
    } catch (e) {
      print('Error calculating score: $e');
      _score = 0.0; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _score;
  }
}

import 'package:flutter/material.dart';
import 'package:fyp1/services/quiz_service.dart';
import 'package:fyp1/model/quiz.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();

  List<Quiz> _quizzes = [];

  List<Quiz> get quizzes => _quizzes;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> fetchQuizzes(int chapter) async {
    _quizService.predefinedQuizzes();
    _isLoading = true;
    notifyListeners();

    _quizzes = await _quizService.getQuizzesByChapter(chapter);
    _isLoading = false;
    notifyListeners();
  }
}

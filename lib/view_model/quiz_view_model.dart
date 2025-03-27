// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/services/note_service.dart';
import 'package:fyp1/services/quiz_answer_service.dart';

class QuizViewModel extends ChangeNotifier {
  final ChapterService _quizService = ChapterService();
  final QuizAnswerService _quizAnswerService = QuizAnswerService();

  Map<String, int> _cachedAnswers = {};
  Timer? _debounceTimer;

  final String _chapterName = "unknown";
  List<Quiz> _quizzes = [];
  final Map<String, List<Quiz>> _quizzesByChapter = {};
  int _score = 0;
  bool _isLoading = false;
  late String _userId;
  late String _chapterId;

  // Getters
  List<Quiz> get quizzes => _quizzes;
  bool get isLoading => _isLoading;
  String get chapterName => _chapterName;
  int get score => _score;
  Map<String, int> get cachedAnswers => _cachedAnswers;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    saveAllAnswersToFirestore();
    super.dispose();
  }

  /// Initializes the QuizViewModel by fetching quizzes and cached answers.
  Future<void> loadData(String userId, String chapterId) async {
    _userId = userId;
    _chapterId = chapterId;
    try {
      await Future.wait([
        fetchQuizData(chapterId),
        fetchUserAnswers(chapterId),
      ]);
    } catch (e) {
      print('Error retrieving answer: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserAnswers(String chapterId) async {
    try {
      _cachedAnswers =
          await _quizAnswerService.getChapterAnswers(_userId, chapterId);
    } catch (e) {
      print('Error retrieving user answer: $e');
    }
  }

  Future<void> fetchQuizData(String chapterId, {bool refresh = false}) async {
    if (!refresh && _quizzesByChapter.containsKey(chapterId)) {
      _quizzes = _quizzesByChapter[chapterId]!;
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      _quizzes = await _quizService.getQuizzesByChapter(chapterId);
      _quizzesByChapter[chapterId] = _quizzes;
    } catch (e) {
      print('Error retrieving answer: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves an answer locally and triggers a debounce to persist answers.
  Future<void> saveAnswerLocally(String quizId, int answer) async {
    _cachedAnswers[quizId] = answer;
    notifyListeners();

    _debounceTimer?.cancel();
    _debounceTimer =
        Timer(const Duration(seconds: 5), saveAllAnswersToFirestore);
  }

  /// Persists all cached answers to Firestore.
  Future<void> saveAllAnswersToFirestore() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _quizAnswerService.saveMultipleQuizAnswers(
          _userId, _chapterId, _cachedAnswers);
      print('Answer saved successfully');
    } catch (e) {
      print('Error saving answer: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Quiz> getQuizById(String chapterID, String quizId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final quiz = await _quizService.getQuizById(chapterID, quizId);
      if (quiz == null) {
        throw Exception('Quiz not found');
      }
      _isLoading = false;
      notifyListeners();
      return quiz;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error fetching quiz: $e');
      throw Exception('Failed to fetch quiz');
    }
  }

  Future<int> calculateScore(String chapter, String userId) async {
    _isLoading = true;
    notifyListeners();

    int correctAnswers = 0; // Counter for correct answers

    try {
      for (Quiz quiz in _quizzes) {
        final quizId = quiz.quizzID;
        final userAnswer = _cachedAnswers[quizId];
        final correctAnswer = quiz.answer;

        //
        if (userAnswer != null && userAnswer == correctAnswer) {
          correctAnswers++;
        }
      }

      // // Calculate the score as a percentage
      // if (_quizzes.isNotEmpty) {
      //   _score = (correctAnswers / _quizzes.length) * 100; // Calculate percentage
      // } else {
      //   _score = 0.0; // Avoid division by zero
      // }
      _score = correctAnswers;
      print('Score calculated: $_score');
    } catch (e) {
      print('Error calculating score: $e');
      _score = 0; // Reset score in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return correctAnswers;
  }

  /// Adds a new quiz to a chapter.
  Future<void> addQuiz(String chapterId, Quiz quiz) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _quizService.addQuizToChapter(chapterId, quiz);
      await fetchQuizData(chapterId, refresh: true);
    } catch (e) {
      print('Error adding quiz: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates an existing quiz in a chapter.
  Future<void> updateQuiz(
      String chapterId, String quizId, Quiz updatedQuiz) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _quizService.updateQuiz(chapterId, quizId, updatedQuiz);
      await fetchQuizData(chapterId, refresh: true);
    } catch (e) {
      print('Error updating quiz: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes a quiz from a chapter.
  Future<void> deleteQuiz(String chapterId, String quizId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _quizService.deleteQuiz(chapterId, quizId);
      await fetchQuizData(chapterId, refresh: true);
    } catch (e) {
      print('Error deleting quiz: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

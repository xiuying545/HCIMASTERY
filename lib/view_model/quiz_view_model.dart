// ignore_for_file: avoid_print

import 'dart:async';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/services/note_service.dart';
import 'package:fyp1/services/quiz_answer_service.dart';
import 'package:fyp1/view_model/base_view_model.dart';

class QuizViewModel extends BaseViewModel {
  final ChapterService _quizService = ChapterService();
  final QuizAnswerService _quizAnswerService = QuizAnswerService();

  Map<String, int> _cachedAnswers = {};
  Timer? _debounceTimer;

  final String _chapterName = "unknown";
  List<Quiz> _quizzes = [];
  final Map<String, List<Quiz>> _quizzesByChapter = {};
  int _score = 0;
  late String _userId;
  late String _chapterId;

  // Getters
  List<Quiz> get quizzes => _quizzes;
  String get chapterName => _chapterName;
  int get score => _score;
  Map<String, int> get cachedAnswers => _cachedAnswers;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    saveAllAnswersToFirestore();
    super.dispose();
  }

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
    }
    notifyListeners();
  }

  Future<void> fetchUserAnswers(String chapterId) async {
    await tryFunction(() async {
      _cachedAnswers =
          await _quizAnswerService.getChapterAnswers(_userId, chapterId);
    });
  }

  Future<void> fetchQuizData(String chapterId, {bool refresh = false}) async {
  
    if (!refresh && _quizzesByChapter.containsKey(chapterId)) {
      _quizzes = _quizzesByChapter[chapterId]!;
      notifyListeners();
      return;
    }

    await tryFunction(() async {
      _quizzes = await _quizService.getQuizzesByChapter(chapterId);
      _quizzesByChapter[chapterId] = _quizzes;
    });
    notifyListeners();
  }

  Future<void> saveAnswerLocally(String quizId, int answer) async {
    _cachedAnswers[quizId] = answer;
    notifyListeners();

    _debounceTimer?.cancel();
    _debounceTimer =
        Timer(const Duration(seconds: 5), saveAllAnswersToFirestore);
  }

  Future<void> saveAllAnswersToFirestore() async {
    await tryFunction(() async {
      await _quizAnswerService.saveMultipleQuizAnswers(
          _userId, _chapterId, _cachedAnswers);
      print('Answer saved successfully');
    });
    notifyListeners();
  }

Future<Quiz> getQuizById(String chapterID, String quizId) async {
  return await tryFunction<Quiz>(() async {
        setLoading(true);
    Quiz? quiz = await _quizService.getQuizById(chapterID, quizId);
        setLoading(false);
    if (quiz == null) {
      throw Exception('Quiz not found');
    }
    return quiz;
  }) as Quiz;
}

  Future<int> calculateScore(String chapter, String userId) async {
    int correctAnswers = 0;

    await tryFunction(() async {
      for (Quiz quiz in _quizzes) {
        final quizId = quiz.quizzID;
        final userAnswer = _cachedAnswers[quizId];
        final correctAnswer = quiz.answer;

        if (userAnswer != null && userAnswer == correctAnswer) {
          correctAnswers++;
        }
      }
      _score = correctAnswers;
      print('Score calculated: $_score');
    });
    notifyListeners();
    return correctAnswers;
  }

  Future<void> addQuiz(String chapterId, Quiz quiz) async {
    await tryFunction(() async {
      await _quizService.addQuizToChapter(chapterId, quiz);
      await fetchQuizData(chapterId, refresh: true);
    });
    notifyListeners();
  }

  Future<void> updateQuiz(
      String chapterId, String quizId, Quiz updatedQuiz) async {
    await tryFunction(() async {
      await _quizService.updateQuiz(chapterId, quizId, updatedQuiz);
      await fetchQuizData(chapterId, refresh: true);
    });
    notifyListeners();
  }

  Future<void> deleteQuiz(String chapterId, String quizId) async {
    await tryFunction(() async {
      await _quizService.deleteQuiz(chapterId, quizId);
      await fetchQuizData(chapterId, refresh: true);
    });
    notifyListeners();
  }
}

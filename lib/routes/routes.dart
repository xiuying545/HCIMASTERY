import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/screen/user/forum/forum.dart';
import 'package:fyp1/screen/user/note/quiz/questionlist.dart';
import 'package:fyp1/screen/user/note/quiz/quiz.dart';
import 'package:fyp1/screen/user/note/quiz/quizAnswer.dart';
import 'package:fyp1/screen/user/note/quiz/quizresult.dart';
import 'package:fyp1/screen/user/practicalExercise/practicalExercise.dart';
import 'package:fyp1/screen/user/profile/profile.dart';
import 'package:go_router/go_router.dart';

GoRouter router() {
  return GoRouter(
  
  initialLocation: '/student/forum',
  routes: [
    // Routes for students
    GoRoute(
      path: '/student/forum',
      builder: (context, state) => const ForumPage(),
    ),
    GoRoute(
      path: '/student/practicalExercise',
      builder: (context, state) => const PracticalExercisePage(),
    ),
  GoRoute(
  path: '/student/quiz',
  builder: (context, state) {
    final quizListJson = state.uri.queryParameters['quizzList'];
    final indexString = state.uri.queryParameters['index'];

    if (quizListJson == null || indexString == null) {
      // Handle the error case (e.g., navigate to an error page or show a message)
      return const Scaffold(
        body: Center(child: Text('Error: Missing quiz data.')),
      );
    }

    final index = int.tryParse(indexString) ?? 0; // Fallback to 0 if parsing fails

    List<dynamic> quizList = jsonDecode(quizListJson);
    List<Quiz> quizzes = quizList.map((quizJson) => Quiz.fromJson(quizJson)).toList();

    return QuizPage(quizzes: quizzes, questionIndex: index);
  },
),
GoRoute(
  path: '/student/quizAnswer',
  builder: (context, state) {
    final String? quizJson = state.uri.queryParameters['quizz'];
    final String? userAnswerString = state.uri.queryParameters['userAnswer'];
    

    if (quizJson == null || userAnswerString == null) {
      return const Scaffold(
        body: Center(child: Text('Error: Missing quiz data.')),
      );
    }

    final userAnswer = int.tryParse(userAnswerString) ?? 0;

    final quizMap = jsonDecode(quizJson);
    final quiz = Quiz.fromJson(quizMap);

    return QuizAnswerPage(quiz: quiz, userAnswer: userAnswer);
  },
),
  GoRoute(
  path: '/student/quizResult/:chapter', // Define the chapter as a parameter
  builder: (context, state) {
final String chapterString = state.pathParameters['chapter']!;
final int chapter = int.parse(chapterString);
    return QuizResultPage(chapter: chapter); 
  },
),
    GoRoute(
      path: '/student/questionlist',
      builder: (context, state) => const QuestionListPage(),
    ),
    GoRoute(
      path: '/student/profile',
      builder: (context, state) => const ProfilePage(),
    ),

    // Routes for teachers
    // GoRoute(
    //   path: '/teacher/dashboard',
    //   builder: (context, state) => TeacherDashboard(),
    // ),
    // GoRoute(
    //   path: '/teacher/quiz-management',
    //   builder: (context, state) => QuizManagementPage(),
    // ),
    // GoRoute(
    //   path: '/teacher/profile',
    //   builder: (context, state) => ProfilePage(), // Teachers can also have a profile
    // ),
  ],
);
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp1/screen/admin/Quiz/addQuiz.dart';
import 'package:fyp1/screen/admin/Quiz/editQuiz.dart';
import 'package:fyp1/screen/admin/addNote.dart';
import 'package:fyp1/screen/admin/editNote.dart';
import 'package:fyp1/screen/admin/manageNote.dart';
import 'package:fyp1/screen/admin/Quiz/manageQuiz.dart';
import 'package:fyp1/screen/mainScren.dart';
import 'package:fyp1/screen/user/note/notePage.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:fyp1/screen/authenication/loginScreen.dart';
import 'package:fyp1/screen/authenication/registerScreen.dart';
import 'package:fyp1/screen/user/forum/EditPost.dart';
import 'package:fyp1/screen/user/forum/PostDetail.dart';
import 'package:fyp1/screen/user/forum/addPost.dart';
import 'package:fyp1/screen/user/forum/forum.dart';
import 'package:fyp1/screen/user/note/mainpage.dart';
import 'package:fyp1/screen/user/note/notelist.dart';
import 'package:fyp1/screen/user/note/quiz/questionlist.dart';
import 'package:fyp1/screen/user/note/quiz/quiz.dart';
import 'package:fyp1/screen/user/note/quiz/quizAnswer.dart';
import 'package:fyp1/screen/user/note/quiz/quizresult.dart';
import 'package:fyp1/screen/user/practicalExercise/practicalExercise.dart';
import 'package:fyp1/screen/user/profile/editProfile.dart';
import 'package:fyp1/screen/user/profile/profile.dart';
import 'package:fyp1/widget/adminnavbar.dart';
import 'package:fyp1/widget/studentnavbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // final firebaseUser = context.watch<UserViewModel?>();
          // if (firebaseUser != null) {
          //   return const Homepage();
          // }
          //  return const SplashScreen();
          return const AdminNavBar();
        },
        //  builder: (context, state) {
        //     final chapterId = "1tVIMjWSBHWuKDGQLWIA";
        //     return ManageNotesPage(chapterId: chapterId);
        //   }
      ),
      GoRoute(
        path: '/admin/addNote/:chapterId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return AddNotePage(chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/admin/manageNote/:chapterId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return ManageNotePage(chapterId: chapterId);
        },
      ),
      GoRoute(
        path: '/admin/manageQuiz/:chapterId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return ManageQuizPage(chapterId: chapterId);
        },
      ),
        GoRoute(
        path: '/admin/addQuiz/:chapterId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return AddQuizPage(chapterId: chapterId);
        },
      ),
        GoRoute(
        path: '/admin/editQuiz/:chapterId/:quizId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
           final quizId = state.pathParameters['quizId']!;
          return EditQuizPage(chapterId: chapterId, quizId: quizId);
        },
      ),
      // Route for EditNotePage
      GoRoute(
        path: '/admin/editNote/:chapterId/:noteId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          final noteId = state.pathParameters['noteId']!;
          return EditNotePage(chapterId: chapterId, noteId: noteId);
        },
      ),
      GoRoute(
          path: '/student/note/:noteID',
          builder: (context, state) {
            final noteID = state.pathParameters['noteID']!;
            return NotePage(noteID: noteID);
          }),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/admin/main',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
          path: '/student/notelist/:chapterId',
          builder: (context, state) {
            final chapterId = state.pathParameters['chapterId']!;
            return NoteListPage(chapterId: chapterId);
          }),
      GoRoute(
        path: '/studentNav',
        builder: (context, state) => const StudentNavBar(),
      ),
      GoRoute(
        path: '/adminNav',
        builder: (context, state) => const AdminNavBar(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpScreen(),
      ),

      GoRoute(
        path: '/nav',
        builder: (context, state) => const StudentNavBar(),
      ),
      GoRoute(
        path: '/student/forum',
        builder: (context, state) => const ForumPage(),
      ),
      GoRoute(
        path: '/student/forum/addPost',
        builder: (context, state) => const CreatePostPage(),
      ),
      GoRoute(
        path: '/student/forum/editPost/:postId',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return EditPostPage(postId: postId);
        },
      ),
      GoRoute(
        path: '/forum/postDetail/:postId',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostDetailPage(postID: postId);
        },
      ),
      // GoRoute(
      //   path: '/practicalExercise',
      //   builder: (context, state) => const PracticalExercisePage(),
      // ),
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

          final index =
              int.tryParse(indexString) ?? 0; // Fallback to 0 if parsing fails

          List<dynamic> quizList = jsonDecode(quizListJson);
          List<Quiz> quizzes =
              quizList.map((quizJson) => Quiz.fromJson(quizJson)).toList();

          return QuizPage(quizzes: quizzes, questionIndex: index);
        },
      ),
      GoRoute(
        path: '/student/quizAnswer',
        builder: (context, state) {
          final String? quizJson = state.uri.queryParameters['quizz'];
          final String? userAnswerString =
              state.uri.queryParameters['userAnswer'];

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
        path:
            '/student/quizResult/:chapter', // Define the chapter as a parameter
        builder: (context, state) {
          final String chapter = state.pathParameters['chapter']!;
          return QuizResultPage(chapter: chapter);
        },
      ),
      GoRoute(
        path: '/student/questionlist/:chapterID',
        builder: (context, state) {
          final String chapterID = state.pathParameters['chapterID']!;

          return QuestionListPage(chapterID: chapterID);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/editProfile/:userId',
        builder: (context, state) {
          final String userId = state.pathParameters['userId']!;

          return EditProfilePage(userId: userId);
        },
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

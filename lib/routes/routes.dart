import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp1/main.dart';
import 'package:fyp1/screen/admin/Quiz/add_quiz.dart';
import 'package:fyp1/screen/admin/Quiz/edit_quiz.dart';
import 'package:fyp1/screen/admin/Note/add_note.dart';
import 'package:fyp1/screen/admin/Note/edit_note.dart';
import 'package:fyp1/screen/admin/Note/manage_note.dart';
import 'package:fyp1/screen/admin/Quiz/manage_quiz.dart';
import 'package:fyp1/screen/user/authenication/edit_password.dart';
import 'package:fyp1/screen/user/authenication/forget_password.dart';
import 'package:fyp1/screen/student/note/note_detail.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/screen/user/authenication/login.dart';
import 'package:fyp1/screen/user/authenication/register.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/coffee_game.dart';
import 'package:fyp1/screen/user/design_challenge/product_page_design.dart';
import 'package:fyp1/screen/user/error_page.dart';
import 'package:fyp1/screen/user/forum/edit_post.dart';
import 'package:fyp1/screen/user/forum/post_detail.dart';
import 'package:fyp1/screen/user/forum/add_post.dart';
import 'package:fyp1/screen/user/forum/forum.dart';
import 'package:fyp1/screen/student/note/main_page.dart';
import 'package:fyp1/screen/student/note/note_list.dart';
import 'package:fyp1/screen/student/quiz/question_list.dart';
import 'package:fyp1/screen/student/quiz/quiz_question.dart';
import 'package:fyp1/screen/student/quiz/quiz_answer.dart';
import 'package:fyp1/screen/student/quiz/quiz_score_list.dart';
import 'package:fyp1/screen/user/design_challenge/profile_page_design.dart';
import 'package:fyp1/screen/user/profile/delete_account.dart';
import 'package:fyp1/screen/user/profile/edit_profile.dart';
import 'package:fyp1/screen/user/profile/profile_page.dart';
import 'package:fyp1/screen/admin/admin_navbar.dart';
import 'package:fyp1/screen/student/student_navbar.dart';
import 'package:go_router/go_router.dart';

GoRouter router() {
  return GoRouter(
    initialLocation: '/',
     navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // final firebaseUser = context.watch<UserViewModel?>();
          // if (firebaseUser != null) {
          //   return const Homepage();
          // }
              //  return  SignInScreen();
          // return const AdminNavBar();
          return  const StudentNavBar(bottomIndex: 1,);
          // return ErrorPage(errorMessage: "hey",);
          // return  DesignChallengesPage();
          // return   CoffeeGame();
            // return  const ProductDesignChallengePage();
          // return ProfileDesignChallengePage();
                      // return ManageNotePage(chapterId: "CtGwccnQVc38I9UeX5cb");
        },
        //  builder: (context, state) {
        //     final chapterId = "1tVIMjWSBHWuKDGQLWIA";
            // return ManageNotesPage(chapterId: "1tVIMjWSBHWuKDGQLWIA");
        //   }
      ),


       GoRoute(
        path: '/practicalExercise/coffeegame',
        builder: (context, state) => const CoffeeGame(),
      ),

             GoRoute(
        path: '/deleteAccount',
        builder: (context, state) => const DeleteAccountPage(),
      ),


                   GoRoute(
        path: '/practicalExercise/productgame',
        builder: (context, state) => const ProductDesignChallengePage(),
      ),
      
      
      GoRoute(
        path: '/admin/addNote/:chapterId',
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return AddNotePage(chapterId: chapterId);
        },
      ),
       GoRoute(
        path: '/practicalExercise/profilePage',
           builder: (context, state) => const ProfileDesignChallengePage(),
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
        path: '/adminNav',
        builder: (context, state) => const AdminNavBar(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/editPassword',
        builder: (context, state) => const EditPasswordScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpScreen(),
      ),
        GoRoute(
        path: '/error',
        builder: (context, state) =>  const ErrorPage(),
      ),

      GoRoute(
        path: '/studentNav',
        builder: (context, state) {
          final index = int.tryParse(state.uri.queryParameters['index'] ?? '');
          return StudentNavBar(bottomIndex: index ?? 0);
        },
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
          final String? quizzID = state.uri.queryParameters['quizzID'];
          // final String? userAnswerString =
          //     state.uri.queryParameters['userAnswer'];

          if (quizzID == null) {
            return const Scaffold(
              body: Center(child: Text('Error: Missing quiz data.')),
            );
          }

          // final quizzIndex = int.tryParse(quizzIndexString);

          // final quizMap = jsonDecode(quizJson);
          // final quiz = Quiz.fromJson(quizMap);

          return QuizAnswerPage(quizzID: quizzID);
        },
      ),
      GoRoute(
        path:
            '/student/quizResult/:chapterID', // Define the chapter as a parameter
        builder: (context, state) {
          final String chapterID = state.pathParameters['chapterID']!;
          return QuizResultPage(chapterID: chapterID);
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

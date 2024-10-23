import 'package:fyp1/screen/user/forum/forum.dart';
import 'package:fyp1/screen/user/note/quiz/questionlist.dart';
import 'package:fyp1/screen/user/note/quiz/quiz.dart';
import 'package:fyp1/screen/user/note/quiz/quizresult.dart';
import 'package:fyp1/screen/user/practicalExercise/practicalExercise.dart';
import 'package:fyp1/screen/user/profile/profile.dart';
import 'package:go_router/go_router.dart';


// Route configuration for both teacher and student
final GoRouter appRouter = GoRouter(
  initialLocation: '/student/quiz',
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
      builder: (context, state) => const QuizPage(),
    ),
    GoRoute(
      path: '/student/quizResult',
      builder: (context, state) =>  QuizResultPage(),
    ),
     GoRoute(
      path: '/student/questionlist',
      builder: (context, state) =>  const QuestionListPage(),
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

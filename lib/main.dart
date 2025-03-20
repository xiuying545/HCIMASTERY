import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp1/view_model/forum_view_model.dart';
import 'package:fyp1/view_model/note_view_model.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:fyp1/routes/routes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => QuizViewModel()),
        ChangeNotifierProvider(create: (context) => ForumViewModel()),
      ],
      child: MaterialApp.router(
        title: 'HCI Mastery',
        routerConfig: router(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fyp1/modelview/forumviewmodel.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:fyp1/routes/routes.dart';
import 'package:provider/provider.dart'; // Import the provider package
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
        ChangeNotifierProvider(create: (context) => QuizViewModel()),
        ChangeNotifierProvider(create: (context) => ForumViewModel()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: router(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  const QuizResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardPage'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the DashboardPage!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

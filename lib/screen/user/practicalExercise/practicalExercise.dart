import 'package:flutter/material.dart';

class PracticalExercisePage extends StatelessWidget {
  const PracticalExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practical Exercise'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Practical Exercise!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

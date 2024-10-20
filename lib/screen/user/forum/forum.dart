import 'package:flutter/material.dart';

class ForumPage extends StatelessWidget {
  const ForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Forum!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

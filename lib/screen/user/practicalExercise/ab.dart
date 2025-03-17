import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CompareDesignsPage(),
    );
  }
}

class CompareDesignsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare UI Designs"),
      ),
      body: PageView(
        children: [
          BadForm(), // Page 1: Bad Design
          GoodForm(), // Page 2: Good Design
        ],
      ),
    );
  }
}

// ❌ Bad Form UI (Poor Design)
class BadForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "❌ Bad Form Design",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(labelText: "Name"), // No border, no spacing
                  ),
                  SizedBox(height: 10), // Poor spacing
                  TextField(
                    decoration: InputDecoration(labelText: "Email"), // No validation
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(labelText: "Password"), // No error handling
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // No validation or error handling
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Form submitted without validation!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
          // Chatbox for justification
          JustificationChatbox(
            questions: [
              "1. What is wrong with the spacing in this form?",
              "2. Why is the lack of input validation a problem?",
              "3. How would you handle errors for invalid email or password?",
              "4. What improvements would you suggest for the button design?",
            ],
          ),
        ],
      ),
    );
  }
}

// ✅ Good Form UI (Improved Design)
class GoodForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "✅ Good Form Design",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          border: OutlineInputBorder(),
                          helperText: "Enter your full name as per ID",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          helperText: "Enter a valid email address",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!value.contains("@")) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          helperText: "Password must be at least 6 characters",
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Form submitted successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Chatbox for justification
          JustificationChatbox(
            questions: [
              "1. What makes the spacing in this form better?",
              "2. How does input validation improve the user experience?",
              "3. Why is error handling important for forms?",
              "4. What makes the button design more effective here?",
            ],
          ),
        ],
      ),
    );
  }
}

// Chatbox Widget for Justification
class JustificationChatbox extends StatelessWidget {
  final List<String> questions;

  const JustificationChatbox({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Justify the Design:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          ...questions.map((question) => Text(
                "• $question",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              )),
        ],
      ),
    );
  }
}
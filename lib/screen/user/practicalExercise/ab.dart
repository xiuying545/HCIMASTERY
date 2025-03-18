import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CompareDesignsPage(),
    );
  }
}

class CompareDesignsPage extends StatelessWidget {
  const CompareDesignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compare UI Designs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔄 Swipe Section (Only this part changes)
            const Text("Swipe to Compare Forms 👇", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.65, // Fixed height for swipeable section
              child: PageView(
                children: [
                  const BadForm(), // Page 1: Bad Design
                  GoodForm(), // Page 2: Good Design
                ],
              ),
            ),
          ]
        )
      )
    );
  }
}

// ❌ Bad Form UI (Poor Design)
class BadForm extends StatelessWidget {
  const BadForm({super.key});

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
                  const Text(
                    "❌ Bad Form Design",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(labelText: "Name"), // No border, no spacing
                  ),
                  const SizedBox(height: 10), // Poor spacing
                  const TextField(
                    decoration: InputDecoration(labelText: "Email"), // No validation
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(labelText: "Password"), // No error handling
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // No validation or error handling
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Form submitted without validation!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
          // Chatbox for justification
        ]
      ),
      
    );
  }
}

// ✅ Good Form UI (Improved Design)
class GoodForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  GoodForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "✅ Good Form Design",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Form submitted successfully!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Chatbox for justification
        
        ],
      ),
    );
  }
}

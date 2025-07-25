// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp1/common/common_widget/custom_input_field.dart';
import 'package:fyp1/common/constant.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:fyp1/model/user.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Profile user = Profile(
          userId: userCredential.user!.uid,
          name: _nameController.text,
          email: _emailController.text.trim(),
          role: ROLE_STUDENT,
        );

        UserViewModel userViewModel =
            Provider.of<UserViewModel>(context, listen: false);
        userViewModel.saveUser(user);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Registration Successful!'),
              backgroundColor: Colors.green),
        );

        // Navigate to the Sign In screen
         GoRouter.of(context).push('/signin');
      
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.message ?? 'Registration Failed'),
              backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.01),
                  Text(
                    "Sign Up",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInputField(
                          label: "Name",
                          controller: _nameController,
                          validators: [
                            (value) {
                              if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                                return 'Name can only contain alphabets.';
                              }
                              return null;
                            },
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        CustomInputField(
                          label: "Email",
                          controller: _emailController,
                          validators: [
                            (value) {
                              if (!RegExp(
                                      r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                                  .hasMatch(value!)) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        CustomInputField(
                          label: "Password",
                          controller: _passwordController,
                          isSecure: true,
                          validators: [
                            (value) {
                              if (value!.length < 6) {
                                return 'Password must be at least 6 characters.';
                              }
                              final passwordPattern = RegExp(
                                  r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).+$');
                              if (!passwordPattern.hasMatch(value)) {
                                return 'Combination of characters, numbers, and special characters.';
                              }
                              return null;
                            },
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        CustomInputField(
                          label: "Confirm Password",
                          controller: _confirmPasswordController,
                          isSecure: true,
                          validators: [
                            (value) {
                              if (value != _passwordController.text) {
                                return 'Password and confirm password do not match.';
                              }
                              return null;
                            },
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _signUp(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.blue.shade900,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                              shape: const StadiumBorder(),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Sign Up"),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go("/signin");
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Already have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign in",
                                  style: TextStyle(color: Color(0xFF6a5ae0)),
                                ),
                              ],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.64),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/common_widget/custom_input_field.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;


  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await _redirectUserBasedOnRole(user.uid);
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _redirectUserBasedOnRole(String userId) async {
    try {
      String? role = await Provider.of<UserViewModel>(context, listen: false)
          .getUserRole(userId);
    
      if (role == null) {
        _showSnackBar("User role not found.");
        return;
      }

      if (mounted) {
        Provider.of<UserViewModel>(context, listen: false).setUserId(userId);
        Provider.of<UserViewModel>(context, listen: false).loadUser(userId);
        String route = role == 'admin' ? '/adminNav' : '/studentNav';
        GoRouter.of(context).go(route);
      }

      await StorageHelper.set("USER_ID", userId); 
      await StorageHelper.set("ROLE", role); 
      await StorageHelper.set("STATUS", "LOGIN"); 
    } catch (e) {
      _showSnackBar("Error retrieving user role.");
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No user found with this email.';
        break;
      case 'wrong-password':
        message = 'Incorrect password. Try again.';
        break;
      case 'invalid-email':
        message = 'Invalid email format.';
        break;
      case 'too-many-requests':
        message = 'Too many failed attempts. Try again later.';
        break;
      default:
        message = 'Failed to sign in. Please try again.';
    }
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _navigateToRegister() {
    GoRouter.of(context).go('/register');
  }

  void _navigateToForgotPassword() {
    GoRouter.of(context).go('/forgotPassword');
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
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Image.asset(
                    'assets/logo.png',
                    height: 300,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInputField(
                          label: "Email",
                          controller: _emailController,
                       
                        ),
                        const SizedBox(height: 16), // Padding

                        CustomInputField(
                          label: "Password",
                          controller: _passwordController,
                          isSecure: true,
                          
                        ),
                        const SizedBox(height: 36),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _signIn,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.blue.shade900,
                            foregroundColor: Colors.white,
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.5, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: _navigateToForgotPassword,
                          child: const Text("Forgot Password?"),
                        ),
                        TextButton(
                          onPressed: _navigateToRegister,
                          child: const Text("Don't have an account? Register"),
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

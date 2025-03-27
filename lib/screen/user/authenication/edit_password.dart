import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common_widget/input_field_icon.dart';
import 'package:go_router/go_router.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Reauthenticate the user with their current password
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );

        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(_newPasswordController.text.trim());

        _showSnackBar("Password updated successfully.");
        if (mounted) {
          GoRouter.of(context).go('/studentNav?index=3');
        }
      } else {
        _showSnackBar("User not logged in.");
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'wrong-password':
        message = 'Incorrect current password.';
        break;
      case 'weak-password':
        message = 'New password is too weak.';
        break;
      default:
        message = 'Failed to update password. Please try again.';
    }
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Password"),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
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
                    height: 200,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Text(
                    "Change Password",
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
                        // Current Password Field
                        CustomInputField(
                          label: "Current Password",
                          controller: _currentPasswordController,
                          isSecure: true,
                        ),
                        const SizedBox(height: 30),
                        CustomInputField(
                          label: "New Password",
                          controller: _newPasswordController,
                          isSecure: true,
                          validators: [
                            (value) {
                         
                              if (value!.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ],
                        ),
                        const SizedBox(height: 16),

                      // Confirm New Password Field
                        CustomInputField(
                          label: "Confirm New Password",
                          controller: _confirmPasswordController,
                          isSecure:
                              true, 
                          validators: [
                            (value) {
                             
                              if (value != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Update Password Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _updatePassword,
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
                                  "Update Password",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/custom_input_field.dart';
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

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text.trim());

        _showSnackBar("Kata laluan berjaya dikemaskini.");
        if (mounted) {
          GoRouter.of(context).go('/studentNav?index=3');
        }
      } else {
        _showSnackBar("Pengguna tidak log masuk.");
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
        message = 'Kata laluan semasa tidak betul.';
        break;
      case 'weak-password':
        message = 'Kata laluan baru terlalu lemah.';
        break;
      default:
        message = 'Gagal mengemaskini kata laluan. Sila cuba lagi.';
    }
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kemaskini Kata Laluan"),
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
                    "Tukar Kata Laluan",
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
                          label: "Kata Laluan Semasa",
                          controller: _currentPasswordController,
                          isSecure: true,
                        ),
                        const SizedBox(height: 30),
                        CustomInputField(
                          label: "Kata Laluan Baru",
                          controller: _newPasswordController,
                          isSecure: true,
                          validators: [
                            (value) {
                              if (value!.length < 6) {
                                return 'Kata laluan mesti sekurang-kurangnya 6 aksara';
                              }
                              final passwordPattern = RegExp(
                                  r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).+$');
                              if (!passwordPattern.hasMatch(value)) {
                                return 'Gabungan huruf, nombor dan simbol diperlukan.';
                              }
                              return null;
                            },
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          label: "Sahkan Kata Laluan Baru",
                          controller: _confirmPasswordController,
                          isSecure: true,
                          validators: [
                            (value) {
                              if (value != _newPasswordController.text) {
                                return 'Kata laluan tidak sepadan';
                              }
                              return null;
                            },
                          ],
                        ),
                        const SizedBox(height: 30),
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
                                  "Kemaskini Kata Laluan",
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

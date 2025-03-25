import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/services/user_service.dart';
import 'package:go_router/go_router.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  Profile? _user;
  String? _userId;
  String? _role;
  Profile? get user => _user;
  String? get userId => _userId;
  String? get role => _role;

  set role(String? role) {
    _role = role;
  }

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  Future<void> loadUser(String userID) async {
    if (_user != null) {
      return;
    }

    _user = await _userService.getUserById(userID);
    notifyListeners();
  }

  Future<void> saveUser(Profile user) async {
    await _userService.addOrUpdateUser(user);
    _user = user;
    notifyListeners();
  }

  Future<void> deleteUser(String email) async {
    await _userService.deleteUser(email);
    if (_user?.email == email) {
      _user = null; // Reset the current user
    }
    notifyListeners();
  }

  Future<List<Profile>> getAllUsers() async {
    return await _userService.getAllUsers();
  }

  Future<String?> getUserRole(String userID) async {
    _role = await _userService.getUserRole(userID);
    return _role;
  }

  Future<String> getUsername(String userId) async {
    return await _userService.getUserName(userId);
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      _userId = null;
      _user = null;
      _role = null;
      notifyListeners();

      if (context.mounted) {
        GoRouter.of(context).go('/signIn');
      }
    } catch (e) {
      // Handle errors (e.g., show a SnackBar)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to logout: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

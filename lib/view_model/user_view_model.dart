import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/services/user_service.dart';
import 'package:go_router/go_router.dart';
import '../main.dart'; // Import where navigatorKey is defined

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  Profile? _user;
  String? _userId;
  String? role;

  bool _isLoading = false;
  bool _isError = false;

  Profile? get user => _user;
  String? get userId => _userId;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  Future<void> loadUser(String userID) async {
    if (_user != null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _user = await _userService.getUserById(userID);
    } catch (e, stackTrace) {
      _handleError(
          e, stackTrace, "Something went wrong when loading the user.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUser(Profile user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.addOrUpdateUser(user);
      _user = user;
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, "Something went wrong when saving the user.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.deleteUser(email);
      if (_user?.email == email) {
        _user = null;
      }
    } catch (e, stackTrace) {
      _handleError(
          e, stackTrace, "Something went wrong when deleting the user.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getUserRole(String userID) async {
    _isLoading = true;
    notifyListeners();

    try {
      role = await _userService.getUserRole(userID);
      return role;
    } catch (e, stackTrace) {
      _handleError(
          e, stackTrace, "Something went wrong when fetching the user role.");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getUsername(String userId) async {
    try {
      return await _userService.getUserName(userId);
    } catch (e, stackTrace) {
      _handleError(
          e, stackTrace, "Something went wrong when fetching the username.");
      return "";
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signOut();
      _userId = null;
      _user = null;
      role = null;

      //redirect to sign in page
      final currentContext = navigatorKey.currentContext;
      if (currentContext != null) {
        GoRouter.of(currentContext).go('/signIn');
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, "Something went wrong when logging out.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Error Handling
  void _handleError(dynamic error, StackTrace stackTrace, String message) {
    _isError = true;
    print("Error: $message $error");

    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    notifyListeners();

    // Redirect to error page
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      GoRouter.of(currentContext).go('/errorPage');
    }
  }
}

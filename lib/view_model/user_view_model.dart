import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/services/user_service.dart';
import 'package:go_router/go_router.dart';

class UserViewModel extends ChangeNotifier {
  //Variable
  final UserService _userService = UserService();
  Profile? _user;
  String? _userId;
  String? role;
  bool _isLoading = false;
  bool _isError = false;
  String? _errorMessage;

  // Getters
  Profile? get user => _user;
  String? get userId => _userId;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String? get errorMessage => _errorMessage;

  // Set the user ID
  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  // Load the user data
  Future<void> loadUser(String userID) async {
    if (_user != null) return;

    _isLoading = true;
    _isError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _userService.getUserById(userID);
    } catch (e) {
      _isError = true;
      _errorMessage = "Something went wrong when loading the user.";
      print("Error: $_errorMessage $e");
      notifyListeners(); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save the user profile when the user updates the profile
  Future<void> saveUser(Profile user) async {
    _isLoading = true;
    _isError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.addOrUpdateUser(user);
      _user = user;
    } catch (e) {
      _isError = true;
      _errorMessage = "Something went wrong when saving the user.";
      print("Error: $_errorMessage $e");
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete the user account
  Future<void> deleteUser(String email) async {
    _isLoading = true;
    _isError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.deleteUser(email);
      if (_user?.email == email) {
        _user = null;
      }
    } catch (e) {
      _isError = true;
      _errorMessage = "Something went wrong when deleting the user.";
      print("Error: $_errorMessage $e");
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get the user role
  Future<String?> getUserRole(String userID) async {
    _isLoading = true;
    _isError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      role = await _userService.getUserRole(userID);
      return role;
    } catch (e) {
      _isError = true;
      _errorMessage = "Something went wrong when fetching the user role.";
      print("Error: $_errorMessage $e");
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get the username
  Future<String> getUsername(String userId) async {
    try {
      return await _userService.getUserName(userId);
    } catch (e) {
      _isError = true;
      _errorMessage = "Something went wrong when fetching the username.";
      print("Error: $_errorMessage $e");
      notifyListeners();
      return "";
    }
  }

  // Logout the user and clear the data in view model
  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    _isError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signOut();
      _userId = null;
      _user = null;
      role = null;
    } catch (e) {
      _isError = true;
      _errorMessage = "Something went wrong when logging out.";
      print("Error: $_errorMessage ${e.toString()}");
      notifyListeners(); // Important to notify UI

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$_errorMessage ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();

      if (context.mounted && !_isError) {
        GoRouter.of(context).go('/signIn');
      }
    }
  }
}

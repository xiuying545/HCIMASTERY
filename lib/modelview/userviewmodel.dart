import 'package:flutter/material.dart';
import 'package:fyp1/model/profile.dart';
import 'package:fyp1/services/user_service.dart';


class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;
  User? get user => _user;

 Future<void> loadUser(String userID) async {
    _user = await _userService.getUserById(userID);  // Load user by userID
    notifyListeners();
  }

  Future<void> saveUser(User user) async {
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

  Future<List<User>> getAllUsers() async {
    return await _userService.getAllUsers();
  }
}

import 'package:flutter/material.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/services/user_service.dart';

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
    _user = await _userService.getUserById(userID); // Load user by userID
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
}

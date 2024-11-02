// user_view_model.dart
import 'package:flutter/material.dart';
import 'package:fyp1/model/profile.dart';


class UserViewModel extends ChangeNotifier {
  // Initializing a UserModel instance with default data
  UserModel _user = UserModel(
    name: "",
    phone: "",
    email: "",
    profileImagePath: null,
  );

  
  String get name => _user.name;
  String get phone => _user.phone;
  String get email => _user.email;
  String? get profileImagePath => _user.profileImagePath;


  void updateName(String newName) {
    _user.name = newName;
    notifyListeners();  
  }

  void updatePhone(String newPhone) {
    _user.phone = newPhone;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _user.email = newEmail;
    notifyListeners();
  }

  void updateProfileImage(String imagePath) {
    _user.profileImagePath = imagePath;
    notifyListeners();
  }

  // You could also add a method to save to an API or database if needed
  Future<void> saveUserData() async {
    // Add code here to save the user data to a database or server
  }
}

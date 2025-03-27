import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp1/main.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/services/user_service.dart';
import 'package:fyp1/view_model/base_view_model.dart';
import 'package:go_router/go_router.dart';

class UserViewModel extends BaseViewModel {
  final UserService _userService = UserService();
  Profile? _user;
  String? _userId;
  String? role;

  Profile? get user => _user;
  String? get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  Future<void> loadUser(String userID) async {
    // if (_user != null) return;
    await tryFunction(() async {
      _user = await _userService.getUserById(userID);

    });
  }

  Future<void> saveUser(Profile user) async {
    await tryFunction(() async {
      await _userService.addOrUpdateUser(user);
      _user = user;
      notifyListeners();
    });
  }

  Future<void> deleteUser(String email) async {
    await tryFunction(() async {
      await _userService.deleteUser(email);
      if (_user?.email == email) _user = null;
    });
  }

  Future<void> logout() async {
    await tryFunction(() async {
      await FirebaseAuth.instance.signOut();
      _userId = null;
      _user = null;
      role = null;
      notifyListeners();
    });
    //redirect to sign in page
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      Future.microtask(() => GoRouter.of(currentContext).go('/signIn'));
    }
  }
}

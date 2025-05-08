import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/common/constant.dart';
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
    
    await tryFunction(() async {
      _user = await _userService.getUserById(userID);
      notifyListeners();
  
    });
      await StorageHelper.set(USER_ID, userID);
    await StorageHelper.set(ROLE, _user!.role);
    await StorageHelper.set(STATUS, STATUS_LOGIN);

  }

  Future<void> saveUser(Profile user) async {
    await tryFunction(() async {
      await _userService.addOrUpdateUser(user);
      _user = user;
      notifyListeners();
    });
  }

  Future<void> deleteUser() async {
    await tryFunction(() async {
      await _userService.deleteUser(_userId!);
      _user = null;
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

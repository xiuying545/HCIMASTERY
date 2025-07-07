import 'package:flutter/material.dart';
import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/common/constant.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:fyp1/screen/user/forum/forum.dart';
import 'package:fyp1/screen/student/note/main_page.dart';
import 'package:fyp1/screen/user/design_challenge/design_challenge_list.dart';
import 'package:fyp1/screen/user/profile/profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StudentNavBar extends StatefulWidget {
  final int bottomIndex;
  const StudentNavBar({super.key, required this.bottomIndex});

  @override
  _StudentNavBar createState() => _StudentNavBar();
}

class _StudentNavBar extends State<StudentNavBar> {
  int _selectedIndex = 0;
  bool _loading = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.bottomIndex;

    final userid = StorageHelper.get(USER_ID);

    if (userid == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).go("/login");
      });
    } else {
      Provider.of<UserViewModel>(context, listen: false)
          .loadUser(userid)
          .then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Widget getBodyWidget(int index) {
      switch (index) {
        case 0:
          return const MainPage();
        case 1:
          return const ForumPage();
        case 2:
          return DesignChallengesPage();
        case 3:
          return const ProfilePage();
        default:
          return const MainPage();
      }
    }

    return Scaffold(
      body: getBodyWidget(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF5),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFFFFFDF5),
            elevation: 0,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            iconSize: 28,
            selectedItemColor: const Color(0xFF2773C8), // Bright blue
            unselectedItemColor: const Color(0xFF9CA3AF), // Soft gray-blue
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.house_outlined),
                activeIcon: Icon(Icons.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Forum',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.extension_outlined),
                activeIcon: Icon(Icons.extension),
                label: 'Exercise',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Me',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

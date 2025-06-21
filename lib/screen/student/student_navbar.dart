import 'package:flutter/material.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:fyp1/screen/user/forum/forum.dart';
import 'package:fyp1/screen/student/note/main_page.dart';
import 'package:fyp1/screen/user/design_challenge/design_challenge_list.dart';
import 'package:fyp1/screen/user/profile/profile_page.dart';
import 'package:provider/provider.dart';

class StudentNavBar extends StatefulWidget {
  final int bottomIndex;
  const StudentNavBar({super.key, required this.bottomIndex});

  @override
  _StudentNavBar createState() => _StudentNavBar();
}

class _StudentNavBar extends State<StudentNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.bottomIndex;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<UserViewModel>(context, listen: false)
    //       .setUserId("s6JpBLQdVzMeMrLQY9ehcVw3P553");
    //   Provider.of<UserViewModel>(context, listen: false).role = "Student";
    //   Provider.of<UserViewModel>(context, listen: false)
    //       .loadUser("s6JpBLQdVzMeMrLQY9ehcVw3P553");
    // });
  }

  @override
  Widget build(BuildContext context) {
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
            selectedItemColor: const Color(0xFF2773C8), // 明亮蓝色
            unselectedItemColor: const Color(0xFF9CA3AF), // 柔和灰蓝
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

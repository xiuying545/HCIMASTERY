import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/forum/forum.dart';
import 'package:fyp1/screen/user/note/quiz/questionlist.dart';
import 'package:fyp1/screen/user/practicalExercise/practicalExercise.dart';
import 'package:fyp1/screen/user/profile/profile.dart';

class StudentNavBar extends StatefulWidget {
  final int bottomIndex;
  const StudentNavBar({super.key, this.bottomIndex = 0});

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
  }

  @override
  Widget build(BuildContext context) {
    Widget getBodyWidget(int index) {
      switch (index) {
        case 0:
          return const QuestionListPage();
        case 1:
          return const ForumPage();
        case 2:
          return const PracticalExercisePage();
        case 3:
          return const ProfilePage();

        default:
          return const QuestionListPage();
      }
    }

    return Scaffold(
      body: getBodyWidget(_selectedIndex), 
      bottomNavigationBar: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: SizedBox(
            height: 80,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.forum),
                  label: 'Forum',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.build),
                  label: 'Exercise',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Me',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color(0xff4a56c1), // Selected item color
              unselectedItemColor: Colors.black, 
              iconSize: 30, 
              showSelectedLabels: true,
              showUnselectedLabels: false, // Unselected item color
              onTap: _onItemTapped,
              backgroundColor:
                  Colors.white, 
               // Background color of the navigation bar
            ),
          ),
        ),
      ),
    );
  }
}

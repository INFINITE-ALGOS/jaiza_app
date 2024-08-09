import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/chat_screen.dart';
import 'package:law_education_app/screens/client_screens/create_job_screen.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/jobs_screen.dart';
import 'package:law_education_app/screens/client_screens/profile_screen.dart';
import 'package:law_education_app/screens/client_screens/search_screen.dart';
import 'package:law_education_app/screens/client_screens/home_screen.dart'; // Adjust the import path as needed

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  int selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ChatScreen(),
    CreateJobScreen(),
    JobsStatusScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add),
              label: 'Create Job',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.briefcase),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person),label: 'Profile')
          ],
          selectedItemColor: blueColor,
          onTap: _onItemTapped,
          currentIndex: selectedIndex,
          elevation: 0,
          backgroundColor: lightGreyColor,
          unselectedItemColor: blackColor,
          unselectedLabelStyle: TextStyle(color: blackColor),
        ),
        body: _widgetOptions.elementAt(selectedIndex),
      ),
    );
  }
}


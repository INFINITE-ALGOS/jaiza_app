import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/chat_screen.dart';
import 'package:law_education_app/screens/client_screens/create_job_screen.dart';
import 'package:law_education_app/screens/client_screens/drawer.dart';
import 'package:law_education_app/screens/client_screens/jobs_status/jobs_screen.dart';
import 'package:law_education_app/screens/client_screens/profile_screen.dart';
import 'package:law_education_app/screens/client_screens/search_screen.dart';
import 'package:law_education_app/screens/client_screens/home_screen.dart'; // Adjust the import path as needed

class BottomNavigationbarClient extends StatefulWidget {
  const BottomNavigationbarClient({super.key});

  @override
  State<BottomNavigationbarClient> createState() => _BottomNavigationbarClientState();
}

class _BottomNavigationbarClientState extends State<BottomNavigationbarClient> {
  double screenHeight = 0;
  double screenWidth = 0;
  int selectedIndex = 0;
  final List<IconData> iconList = [
    Icons.home_outlined,
    Icons.chat_bubble_outline,
    Icons.work_outline,
    Icons.person_2_outlined,
  ];

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ChatScreen(),
    JobsStatusScreen(),
    ProfileScreenClient(),
  ];

  final List<String> labelText =
  [
    'Home',
    'Chat',
    'Jobs',
    'Profile',
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
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Color(0xFF2196f3),
        ),
        body: _widgetOptions[selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateJobScreen(),),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Adjust radius here
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconList[index],
                  size: 24,
                  color: isActive ? Colors.blue : Colors.grey,
                ),
                Text(
                  labelText[index],
                  style: TextStyle(
                    color: isActive ? Colors.blue : Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            );
          },
          activeIndex: selectedIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => selectedIndex = index),
        ),
      ),
    );
  }
}


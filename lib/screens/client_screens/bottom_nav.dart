import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
<<<<<<< Updated upstream
import 'package:law_education_app/provider/general_provider.dart';
import 'package:law_education_app/provider/get_lawyers_provider.dart';
=======
import 'package:law_education_app/provider/get_categories_provider.dart';
>>>>>>> Stashed changes
import 'package:provider/provider.dart';
import '../../provider/language_provider.dart'; // Adjust the import path as needed
import '../client_screens/chat_screen.dart';
import '../client_screens/create_job_screen.dart';
import '../client_screens/drawer.dart';
import '../client_screens/jobs_status/jobs_screen.dart';
import 'chats_screen.dart';
import '../client_screens/home_screen.dart';

class BottomNavigationbarClient extends StatefulWidget {
  int selectedIndex;
   BottomNavigationbarClient({super.key,required this.selectedIndex});

  @override
  State<BottomNavigationbarClient> createState() => _BottomNavigationbarClientState();

}

class _BottomNavigationbarClientState extends State<BottomNavigationbarClient> {
  double screenHeight = 0;
  double screenWidth = 0;
//  int selectedIndex = 0;
  final List<IconData> iconList = [
    Icons.home_outlined,
    Icons.chat_bubble_outline,
    Icons.chat,
    Icons.person_2_outlined,
  ];

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ChatScreen(),
   const Chats(),
    const JobsStatusScreen(),

  ];

  final List<String> labelText = [
    'Home',
    'Chat',
   'Chats',
    'All Jobs',
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const CustomDrawerClient(),
      appBar: AppBar(
<<<<<<< Updated upstream
       // backgroundColor: const Color(0xFF2196f3),
=======
        backgroundColor:primaryColor,
>>>>>>> Stashed changes
        actions: [
          PopupMenuButton<Locale>(
            onSelected: (Locale locale) {
              Provider.of<LanguageProvider>(context, listen: false).setLocale(locale);
            },
            icon: const Icon(Icons.language),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('ur'),
                child: Text('اردو'),
              ),
            ],
          ),
        ],
      ),
      body: _widgetOptions[widget.selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateJobScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Adjust radius here
        ),
        child: const Icon(Icons.add,color: whiteColor,),
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
<<<<<<< Updated upstream
                color: isActive ? primaryColor : Colors.grey,
=======
                color: isActive ? primaryColor: Colors.grey,
>>>>>>> Stashed changes
              ),
              Text(
                labelText[index],
                style: TextStyle(
<<<<<<< Updated upstream
                  color: isActive ? primaryColor : Colors.grey,
=======
                  color: isActive ?primaryColor : Colors.grey,
>>>>>>> Stashed changes
                  fontSize: 10,
                ),
              ),
            ],
          );
        },
        activeIndex: widget.selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() {
            widget.selectedIndex = index;
          });
        },
      ),
    );
  }
}

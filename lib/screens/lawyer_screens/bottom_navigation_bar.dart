import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:law_education_app/screens/lawyer_screens/services_status/jobs_screen.dart';
import 'package:provider/provider.dart';
import 'package:law_education_app/provider/language_provider.dart';
import 'package:law_education_app/screens/lawyer_screens/create_service_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/drawer.dart';

import '../../provider/get_categories_provider.dart';
import 'chat_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class BottomNavigationLawyer extends StatefulWidget {
  int selectedIndex;
   BottomNavigationLawyer({super.key,required this.selectedIndex});

  @override
  State<BottomNavigationLawyer> createState() => _BottomNavigationLawyerState();
}

class _BottomNavigationLawyerState extends State<BottomNavigationLawyer> {

  final List<IconData> iconList = [
    Icons.home_outlined,
    Icons.chat_bubble_outline,
    Icons.work_outline,
    Icons.person_2_outlined,
  ];

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreenLawyer(),
    const ChatScreenLawyer(),
    const ChatScreenLawyer(),
    JobsStatusScreenLawyer(),
  ];

  final List<String> labelText = [
    'Home',
    'Chat',
    'Jobs',
    'All Services',
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }
@override
void didChangeDependencies() {
  Provider.of<CategoriesProvider>(context).getCategories();
  // TODO: implement didChangeDependencies
  super.didChangeDependencies();
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawerLawyer(),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.hello_lawyer),
          backgroundColor: Colors.blue,
          actions: [
            PopupMenuButton<Locale>(
              onSelected: (Locale locale) {
                Provider.of<LanguageProvider>(context, listen: false)
                    .setLocale(locale);
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
                builder: (context) => const CreateServiceScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
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
          activeIndex: widget.selectedIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

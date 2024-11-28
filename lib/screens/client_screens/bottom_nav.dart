import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/provider/general_provider.dart';
import 'package:law_education_app/provider/get_lawyers_provider.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/chat/AllChat.dart';
import 'package:law_education_app/screens/chat_bot/chat_bot.dart';
import 'package:provider/provider.dart';
import '../../controllers/get_location_controller.dart';
import '../../provider/language_provider.dart'; // Adjust the import path as needed
import '../client_screens/chat_screen.dart';
import '../client_screens/create_job_screen.dart';
import '../client_screens/drawer.dart';
import '../client_screens/jobs_status/jobs_screen.dart';
import 'chats_screen.dart';
import '../client_screens/home_screen.dart';
import 'package:http/http.dart' as http;

class BottomNavigationbarClient extends StatefulWidget {
  int selectedIndex;
  bool freshLogin;

  BottomNavigationbarClient(
      {super.key, required this.selectedIndex, this.freshLogin = false});

  @override
  State<BottomNavigationbarClient> createState() =>
      _BottomNavigationbarClientState();
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
    const MyChats(),
    ChatBotScreen(),
    const JobsStatusScreen(),
  ];

  final List<String> labelText = [
    'Home',
    'Chat',
    'AI Bot',
    'All Jobs',
  ];
  String? selectedSearchLocation;
  final getLocationController = GetLocationController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.freshLogin) {
      Future.delayed(Duration.zero, () {
        _showLocationDialog();
      });
    }
  }

  void _showLocationDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Select Location'),
            content: Text('Choose how you want to select your location:'),
            actions: <Widget>[
              TextButton(
                child: Text('Current Location',style: TextStyle(color: primaryColor),),
                onPressed: () async {
                  try {
                    final Position? position =
                        await getLocationController.checkAndRequestLocation();
                    await getLocationController.storeUserLocation(position!,context);
                    Navigator.of(context).pop(); // Close the dialog

                    // Close the dialog first
                  } catch (e) {
                    print('Error: $e');

                    // Show error message to user if needed
                  }
                },
              ),
              TextButton(
                child: Text('Search Location',style: TextStyle(color: primaryColor)),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog first
                  _showSearchLocationDialog(); // Then show the search location dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchLocationDialog() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SearchLocationDialog(
          onLocationSelected: (location) async {
            // Extract latitude and longitude using regular expressions
            RegExp latLngRegex = RegExp(r'Lat: ([\d\.\-]+), Lng: ([\d\.\-]+)');
            Match? match = latLngRegex.firstMatch(location);
            double latitude = 0;
            double longitude = 0;
            if (match != null) {
              // Convert extracted latitude and longitude to doubles
              latitude = double.parse(match.group(1)!);
              longitude = double.parse(match.group(2)!);
            }
           await Provider.of<MyProfileProvider>(context,listen: false).updateProfileData({
              'address': location,
              'location': {'longitude': longitude, 'latitude': latitude}
            });

          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const CustomDrawerClient(),
      appBar: AppBar(
        // backgroundColor: const Color(0xFF2196f3),
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
              builder: (context) => const CreateJobScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Adjust radius here
        ),
        child: const Icon(
          Icons.add,
          color: whiteColor,
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
                color: isActive ? primaryColor : Colors.grey,
              ),
              Text(
                labelText[index],
                style: TextStyle(
                  color: isActive ? primaryColor : Colors.grey,
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

class SearchLocationDialog extends StatefulWidget {
  final Function(String) onLocationSelected;

  SearchLocationDialog({required this.onLocationSelected});

  @override
  _SearchLocationDialogState createState() => _SearchLocationDialogState();
}

class _SearchLocationDialogState extends State<SearchLocationDialog> {
  TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
  var longitude = '';
  var latitude = '';

  bool _loading = false;

  // Search for locations using LocationIQ API
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _loading = true; // Start loading indicator
    });

    final apiKey =
        'pk.0966951ff8a5497ff24ff948e84b4629'; // Replace with your actual API key
    final url = Uri.parse(
        'https://api.locationiq.com/v1/autocomplete.php?key=$apiKey&q=$query&country=PK&format=json');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      if (mounted) {
        setState(() {
          searchResults = data
              .map<String>((item) =>
                  '${item['display_name']} (Lat: ${item['lat']}, Lng: ${item['lon']})')
              .toList();
          _loading = false; // Stop loading indicator
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _loading = false; // Stop loading indicator if there is an error
        });
      }
      print('Error: ${response.reasonPhrase}'); // Log the error reason
      throw Exception('Failed to load locations: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> filterResults = searchResults
        .where((result) => result.toLowerCase().contains('pakistan'))
        .toList();

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text('Search Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter location name',
              ),
              onChanged: (value) {
                _searchLocation(value);
              },
            ),
            SizedBox(height: 10),
            _loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filterResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filterResults[index]),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onLocationSelected(filterResults[index]);
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

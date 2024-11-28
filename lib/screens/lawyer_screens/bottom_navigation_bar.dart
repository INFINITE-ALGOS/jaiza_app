import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:law_education_app/controllers/get_location_controller.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/chat/AllChat.dart';
import 'package:law_education_app/screens/lawyer_screens/all_jobs_screens.dart';
import 'package:law_education_app/screens/lawyer_screens/services_status/service_screen.dart';
import 'package:provider/provider.dart';
import 'package:law_education_app/provider/language_provider.dart';
import 'package:law_education_app/screens/lawyer_screens/create_service_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/drawer.dart';

import '../../provider/general_provider.dart';
import 'all_clients_screen.dart';
import 'chat_screen.dart';
import 'home_screen.dart';
import 'profile_screen(lawyer).dart';

class BottomNavigationLawyer extends StatefulWidget {
  int selectedIndex;
  bool freshLogin;
  BottomNavigationLawyer(
      {super.key, required this.selectedIndex, this.freshLogin = false});

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
  bool _isLocationUpdated = false;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreenLawyer(),
    const MyChats(),
    const AllClientsScreen(),
    const ServiceStatusScreenLawyer(),
  ];

  final List<String> labelText = [
    'Home',
    'Chat',
    'AI Bot',
    'All Services',
  ];
  String? selectedSearchLocation;
  final getLocationController = GetLocationController();

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

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
          canPop:  false,
          child: AlertDialog(
            title: Text('Select Location'),
            content: Text('Choose how you want to select your location:'),
            actions: <Widget>[
              TextButton(
                child: Text('Current Location',style: TextStyle(color: primaryColor)),
                onPressed: () async {
                  try {
                   // Navigator.of(context).pop(); // Close the dialog
                    final Position? position = await getLocationController.checkAndRequestLocation();
                    await getLocationController.storeUserLocation(position!,context);
                    Navigator.of(context).pop(); // Close the dialog first
                    print('Location retrieved: ');
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
    return Consumer<MyProfileProvider>(
      builder: (context, profileProvider, child) {
        // Check if profileData is null or empty
        final profileData = profileProvider.profileData;
        if (profileData.isEmpty) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Show loading until data is fetched
        }

        return Scaffold(
          drawer: CustomDrawerLawyer(), // Now, profileData is populated
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.helloLawyer),
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const CreateServiceScreen(),
              //   ),
              // );
              //getLoc();
            },
            child: const Icon(Icons.add, color: whiteColor),
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
            onTap: _onItemTapped,
          ),
        );
      },
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
  var longitude='';
  var latitude='';

  bool _loading = false;

  // Search for locations using LocationIQ API
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _loading = true; // Start loading indicator
    });

    final apiKey = 'pk.0966951ff8a5497ff24ff948e84b4629'; // Replace with your actual API key
    final url = Uri.parse(
        'https://api.locationiq.com/v1/autocomplete.php?key=$apiKey&q=$query&country=PK&format=json');

    final response = await http.get(url);


    if (response.statusCode == 200) {
      List data = json.decode(response.body);
     if(mounted){
       setState(() {
         searchResults = data
             .map<String>((item) =>
         '${item['display_name']} (Lat: ${item['lat']}, Lng: ${item['lon']})')
             .toList();
         _loading = false; // Stop loading indicator
       });
     }
    } else {
     if(mounted){
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
    List<String> filterResults = searchResults.where((result) => result.toLowerCase().contains('pakistan')).toList();


    return PopScope(
      canPop:  false,
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

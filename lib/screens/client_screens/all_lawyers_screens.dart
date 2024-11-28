import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/provider/get_lawyers_provider.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/client_screens/see_lawyer_profile.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;
import '../../conts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllLawyersScreens extends StatefulWidget {
  const AllLawyersScreens({super.key});

  @override
  State<AllLawyersScreens> createState() => _AllLawyersScreensState();
}

class _AllLawyersScreensState extends State<AllLawyersScreens> {
  double screenHeight = 0;
  double screenWidth = 0;
  int selectedOption = -1;
  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the Earth in km
    var dLat = _toRadians(lat2 - lat1);
    var dLon = _toRadians(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c; // Distance in km
  }

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allLawyers = []; // Holds all lawyers data
  List<Map<String, dynamic>> filteredLawyers =
      []; // Holds filtered lawyers based on search
  bool result = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterLawyers();
    });
  }

  // Filter lawyers based on search text
  void filterLawyers() {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      filteredLawyers = allLawyers.where((lawyer) {
        final name = lawyer['name'].toLowerCase();

        // Get the expertise list and ensure it's non-null and a list
        final expertiseList =
            lawyer['lawyerProfile']['expertise'] as List<dynamic>?;
        // Check if name contains the search term
        final nameMatches = name.contains(searchTerm);

        // Check if any of the expertise items matches the search term
        bool expertiseMatches = false;
        if (expertiseList != null) {
          expertiseMatches = expertiseList
              .any((expertise) => expertise.toLowerCase().contains(searchTerm));
        }

        // Return true if either the name or expertise matches the search term
        return nameMatches || expertiseMatches;
      }).toList();
      if (filteredLawyers.isEmpty) {
        result = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.075,
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .searchByNameOrExpertise,
                        border: InputBorder.none,
                        icon:
                            const Icon(CupertinoIcons.search, color: greyColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Sort By"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Options as ListTiles with tick sign if selected
                                  ListTile(
                                    title: Text("Location"),
                                    trailing: selectedOption == 0
                                        ? Icon(Icons.check)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        selectedOption =
                                            0; // Mark Location as selected
                                      });
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                  ),
                                  ListTile(
                                    title: Text("Experience"),
                                    trailing: selectedOption == 1
                                        ? Icon(Icons.check)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        selectedOption =
                                            1; // Mark Experience as selected
                                      });
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                  ),
                                  ListTile(
                                    title: Text("Rating"),
                                    trailing: selectedOption == 2
                                        ? Icon(Icons.check)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        selectedOption =
                                            2; // Mark Rating as selected
                                      });
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text("Sort By"))
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future:
                    Provider.of<GetLawyersProvider>(context).getAllLawyers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingShimmer();
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                        child:
                            Text(AppLocalizations.of(context)!.noLawyersFound));
                  } else {
                    allLawyers = snapshot.data!;
                    if (filteredLawyers.isEmpty && result == true) {
                      filteredLawyers = allLawyers;
                      return _buildGridView(); // Initially, show all lawyers
                    }
                    if (filteredLawyers.isEmpty && result == false) {
                      //filteredLawyers = allLawyers;
                      return Center(
                        child: Text(AppLocalizations.of(context)!
                            .noMatchingResultFound),
                      ); // Initially, show all lawyers
                    } else {
                      return _buildGridView();
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return GridView.builder(
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300]!,

                    //shape: BoxShape.circle, // Makes the container circular
                  ),
                  // clipBehavior: Clip.hardEdge, // Ensures the image is clipped to the circular border
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  height: 10.0,
                  width: screenWidth * 0.2,
                  color: Colors.grey[300], // Placeholder for text
                ),
              ],
            ),
          ),
        );
      },
    ); // Your existing shimmer loading code...
  }

  Widget _buildGridView() {
    return GridView.builder(
      itemCount: filteredLawyers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final myProfileProvider=Provider.of<MyProfileProvider>(context);
        final Map<String,dynamic> myProfile=myProfileProvider.profileData;

        if (selectedOption == 0) {
          filteredLawyers.sort((a, b) {
            double distanceA = 0;
            double distanceB = 0;

            if (a['location'] != null && a['location']['latitude'] != null && a['location']['longitude'] != null) {
              distanceA = _calculateDistance(
                myProfile['location']['latitude'],
                myProfile['location']['longitude'],
                a['location']['latitude'],
                a['location']['longitude'],
              );
            }

            if (b['location'] != null && b['location']['latitude'] != null && b['location']['longitude'] != null) {
              distanceB = _calculateDistance(
                myProfile['location']['latitude'],
                myProfile['location']['longitude'],
                b['location']['latitude'],
                b['location']['longitude'],
              );
            }
            else{print('empty');}

            // Compare distances
            return distanceA.compareTo(distanceB);
          });
        }

        if (selectedOption == 1) {
          filteredLawyers.sort((a, b) => b['lawyerProfile']['experience']
              .compareTo(a['lawyerProfile']['experience']));
        }
        if (selectedOption == 2) {
          filteredLawyers.sort((a, b) => (b['rating']).compareTo(a['rating']));
        }

        final lawyer = filteredLawyers[index];
        final name = lawyer['name'];
        final url = lawyer['url'];
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SeeLawyerProfile(lawyer: lawyer)));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.12,
                    width: screenWidth * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: lightGreyColor, width: 1),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      height: 100,
                      width: double.infinity,
                      imageUrl: url,
                      placeholder: (context, url) =>
                          CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    name,overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

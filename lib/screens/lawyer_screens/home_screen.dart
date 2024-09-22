import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:intl/intl.dart';
import 'package:law_education_app/controllers/my_services_check_controller.dart';
import 'package:law_education_app/provider/get_clients_provider.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/lawyer_screens/alljobs_realtedto_category.dart';
import 'package:law_education_app/screens/lawyer_screens/see_client_profile.dart';
import 'package:provider/provider.dart';
import '../../conts.dart';
import '../../provider/general_provider.dart';
import '../../widgets/crousel_slider.dart';
import 'all_clients_screen.dart';
import 'all_jobs_screens.dart';
import 'law_books_screen.dart';

class HomeScreenLawyer extends StatefulWidget {
  const HomeScreenLawyer({super.key});

  @override
  State<HomeScreenLawyer> createState() => _HomeScreenLawyerState();
}

class _HomeScreenLawyerState extends State<HomeScreenLawyer> {
  double screenHeight = 0;
  double screenWidth = 0;
  List<Map<String, dynamic>> initialClients = [];

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<MyProfileProvider>(context);
    final generalProvider = Provider.of<GeneralProvider>(context);
    List<String> crouselUrls = generalProvider.crouselUrlList;
    final profileData = profileProvider.profileData;
    final clientProvider = Provider.of<GetClientsProvider>(context);
    initialClients = clientProvider.initialClients;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (profileData == null || profileData['lawyerProfile'] == null) {
      return Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(), // Show loading until profileData is fetched
        ),
      );
    }

    final List<dynamic> selectedCategories =
        profileData['lawyerProfile']['expertise'] ?? [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child:  Row(
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      color: greyColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.currentLocation,
                          style: TextStyle(fontSize: 12, color: greyColor),
                        ),
                        Text(
                          AppLocalizations.of(context)!.newYorkCity,
                          style: TextStyle(fontSize: 12, color: blackColor),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(CupertinoIcons.bell),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.075,
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: lightGreyColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.search,
                        color: greyColor,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        AppLocalizations.of(context)!.search,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: ImageCarousel(crouselUrls: crouselUrls),
            ),
            SizedBox(height: screenHeight * 0.01),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
            ),
            Container(height: screenHeight * 0.01, color: lightGreyColor),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                         Text(
                          AppLocalizations.of(context)!.jobs,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AllJobsScreen()),
                            );
                          },
                          child:  Text(
                            AppLocalizations.of(context)!.viewAllDoubleArrow,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: generalProvider.categoriesMap.length,
                        itemBuilder: (context, index) {
                          // Get the key and category data
                          String key = generalProvider.categoriesMap.keys
                              .elementAt(index);
                          Map<String, dynamic> category =
                              generalProvider.categoriesMap[key];
                          final String url = category['url'];
                          final String name = category['name'];

                          // Check if the category name is in the selectedCategories list
                          if (selectedCategories.contains(name)) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AllJobsRelatedToCategory(
                                            name: name, url: url),
                                  ),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, right: 15),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.12,
                                        width: screenWidth * 0.28,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: lightGreyColor,
                                            width: 1,
                                          ),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: Image.network(
                                          url,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: screenHeight * 0.01, color: lightGreyColor),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.005, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                         Text(
                           AppLocalizations.of(context)!.clients,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AllClientsScreen()),
                            );
                          },
                          child:  Text(
                            AppLocalizations.of(context)!.viewAllDoubleArrow,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: initialClients.length,
                          itemBuilder: (context, index) {
                            final client = initialClients[index];
                            final String name = initialClients[index]['name'];
                            final String url = initialClients[index]['url'];

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SeeClientProfile(
                                              client: client,
                                            )));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, right: 15),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                          height: screenHeight * 0.12,
                                          width: screenWidth * 0.28,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: lightGreyColor,
                                              width: 1,
                                            ),
                                            //shape: BoxShape.circle, // Makes the container circular
                                          ),
                                          clipBehavior: Clip
                                              .hardEdge, // Ensures the image is clipped to the circular border
                                          child: CachedNetworkImage(
                                            height: 100, width: double.infinity,
                                            imageUrl: url,
                                            placeholder: (context, url) =>
                                                CupertinoActivityIndicator(), // Loading widget
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            fit: BoxFit
                                                .cover, // Fallback when image not found
                                          )),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: screenHeight * 0.01, color: lightGreyColor),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                         Text(
                           AppLocalizations.of(context)!.lawBooks,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LawBooksLawyer()),
                            );
                          },
                          child:  Text(
                            AppLocalizations.of(context)!.viewAllDoubleArrow,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, right: 15),
                              child: Container(
                                child: Column(
                                  children: [
                                    Placeholder(
                                      fallbackHeight: screenHeight * 0.12,
                                      fallbackWidth: screenWidth * 0.28,
                                    ),
                                    Text(
                                      "Book Title",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewAllMyService extends StatefulWidget {
  const ViewAllMyService({super.key});

  @override
  State<ViewAllMyService> createState() => _ViewAllMyServiceState();
}

class _ViewAllMyServiceState extends State<ViewAllMyService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: whiteColor,
        // height: MediaQuery.of(context).size.height * 0.3,
        //  child: FutureBuilder<List<Map<String, dynamic>>>(
        //    future: MyServicesCheckController().myServicesCheckMethod(context: context),
        //    builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        //      if (snapshot.connectionState == ConnectionState.waiting) {
        //        return const Center(child: CircularProgressIndicator());
        //      } else if (snapshot.hasError) {
        //        return Center(
        //          child: Text(
        //            'Error: ${snapshot.error}',
        //            style: const TextStyle(color: Colors.red, fontSize: 16),
        //          ),
        //        );
        //      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //        return const Center(
        //          child: Text(
        //            'You have not created any service',
        //            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        //          ),
        //        );
        //      } else {
        //        final List<Map<String, dynamic>> myServices = snapshot.data!;
        //
        //        return ListView.builder(
        //          scrollDirection: Axis.vertical,
        //          itemCount: myServices.length,
        //          itemBuilder: (context, index) {
        //            final Timestamp timestamp = myServices[index]['createdOn'] as Timestamp;
        //            final DateTime dateTime = timestamp.toDate();
        //            final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
        //
        //            return Container(
        //              color: whiteColor,
        //              width: MediaQuery.of(context).size.width * 0.6,
        //              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        //              child: Card(
        //                color: whiteColor,
        //                elevation: 8.0,
        //                shape: RoundedRectangleBorder(
        //                  borderRadius: BorderRadius.circular(10.0),
        //                ),
        //                child: Padding(
        //                  padding: const EdgeInsets.all(16.0),
        //                  child: Column(
        //                    crossAxisAlignment: CrossAxisAlignment.start,
        //                    children: [
        //                      Text(
        //                        'Created on: $formattedDate',
        //                        style: const TextStyle(
        //                          fontWeight: FontWeight.bold,
        //                          fontSize: 16,
        //                        ),
        //                      ),
        //                      const SizedBox(height: 8.0),
        //                      Text(
        //                        myServices[index]['title'] ?? 'No Title',
        //                        style: const TextStyle(
        //                          fontSize: 18,
        //                          fontWeight: FontWeight.w600,
        //                        ),
        //                      ),
        //                      const SizedBox(height: 4.0),
        //                      Text(
        //                        myServices[index]['description'] ?? 'No Description',
        //                        style: TextStyle(
        //                          fontSize: 14,
        //                          color: Colors.grey[700],
        //                        ),
        //                      ),
        //                      const SizedBox(height: 8.0),
        //                      Text(
        //                        '\$${myServices[index]['price'] ?? '0.00'}',
        //                        style: const TextStyle(
        //                          fontSize: 16,
        //                          color: Colors.green,
        //                          fontWeight: FontWeight.bold,
        //                        ),
        //                      ),
        //                    ],
        //                  ),
        //                ),
        //              ),
        //            );
        //          },
        //        );
        //      }
        //    },
        //  ),
      ),
    );
  }
}

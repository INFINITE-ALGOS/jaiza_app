import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:law_education_app/controllers/my_services_check_controller.dart';
import 'package:law_education_app/screens/lawyer_screens/alljobs_realtedto_category.dart';
import 'package:provider/provider.dart';
import '../../conts.dart';
import '../../provider/get_categories_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final categoryProvider=Provider.of<CategoriesProvider>(context);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: const Row(
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
                          "Current Location",
                          style: TextStyle(fontSize: 12, color: greyColor),
                        ),
                        Text(
                          "New York city",
                          style: TextStyle(fontSize: 12, color: blackColor),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(CupertinoIcons.bell)
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
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Search",
                        style:
                        TextStyle(color: Colors.black.withOpacity(0.6)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //SizedBox(height: screenHeight*0.01,),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Placeholder(
                fallbackHeight: screenHeight * 0.23,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),

            //SERVICES WIDGET
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "My Services",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ViewAllMyService()));
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    // Container(
                    //   height: screenHeight * 0.3,
                    //   child: Container(
                    //     color: whiteColor,
                    //     height: MediaQuery.of(context).size.height * 0.3,
                    //     child: FutureBuilder<List<Map<String, dynamic>>>(
                    //       future: MyServicesCheckController().myServicesCheckMethod(context: context),
                    //       builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    //         if (snapshot.connectionState == ConnectionState.waiting) {
                    //           return const Center(child: CircularProgressIndicator());
                    //         } else if (snapshot.hasError) {
                    //           return Center(
                    //             child: Text(
                    //               'Error: ${snapshot.error}',
                    //               style: const TextStyle(color: Colors.red, fontSize: 16),
                    //             ),
                    //           );
                    //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    //           return const Center(
                    //             child: Text(
                    //               'You have not created any service',
                    //               style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    //             ),
                    //           );
                    //         } else {
                    //           final List<Map<String, dynamic>> myServices = snapshot.data!;
                    //
                    //           return ListView.builder(
                    //             scrollDirection: Axis.horizontal,
                    //             itemCount: myServices.length,
                    //             itemBuilder: (context, index) {
                    //               final Timestamp timestamp = myServices[index]['createdOn'] as Timestamp;
                    //               final DateTime dateTime = timestamp.toDate();
                    //               final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                    //
                    //               return Container(
                    //                 color: whiteColor,
                    //                 width: MediaQuery.of(context).size.width * 0.6,
                    //                 margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    //                 child: Card(
                    //                   color: whiteColor,
                    //                   elevation: 8.0,
                    //                   shape: RoundedRectangleBorder(
                    //                     borderRadius: BorderRadius.circular(10.0),
                    //                   ),
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.all(16.0),
                    //                     child: Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         Text(
                    //                           'Created on: $formattedDate',
                    //                           style: const TextStyle(
                    //                             fontWeight: FontWeight.bold,
                    //                             fontSize: 16,
                    //                           ),
                    //                         ),
                    //                         const SizedBox(height: 8.0),
                    //                         Text(
                    //                           myServices[index]['title'] ?? 'No Title',
                    //                           style: const TextStyle(
                    //                             fontSize: 18,
                    //                             fontWeight: FontWeight.w600,
                    //                           ),
                    //                         ),
                    //                         const SizedBox(height: 4.0),
                    //                         Text(
                    //                           myServices[index]['description'] ?? 'No Description',
                    //                           style: TextStyle(
                    //                             fontSize: 14,
                    //                             color: Colors.grey[700],
                    //                           ),
                    //                         ),
                    //                         const SizedBox(height: 8.0),
                    //                         Text(
                    //                           '\$${myServices[index]['price'] ?? '0.00'}',
                    //                           style: const TextStyle(
                    //                             fontSize: 16,
                    //                             color: Colors.green,
                    //                             fontWeight: FontWeight.bold,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           );
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.01,
              color: lightGreyColor,
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Jobs",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllJobsScreen()));
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryProvider.categoriesList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>AllJobsRelatedToCategory(categoryName: categoryProvider.categoriesList[index])));},
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 15, right: 15),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.12,
                                        width: screenWidth * 0.24,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            border: Border.all(
                                                color: lightGreyColor,
                                                width: 1)),
                                        child: const Center(
                                          child: Icon(
                                              Icons.miscellaneous_services),
                                        ),
                                      ),
                                      Text(
                                        categoryProvider.categoriesList[index],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.01,
              color: lightGreyColor,
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            //LAWEYSRS SCREEN
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.005, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Clients",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllClientsScreen()));
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.25,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(right: 25, top: 15),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Placeholder(
                                      fallbackHeight: screenHeight * 0.12,
                                      fallbackWidth: screenWidth * 0.2,
                                    ),
                                    SizedBox(height: screenHeight*0.02,),
                                    const Text(
                                      "name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.01,
              color: lightGreyColor,
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Law Books",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const LawBooksLawyer()));
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        )
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
                                    Container(
                                      height: screenHeight * 0.12,
                                      width: screenWidth * 0.24,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          border: Border.all(
                                              color: lightGreyColor,
                                              width: 1)),
                                      child: const Center(
                                        child: Icon(
                                            Icons.miscellaneous_services),
                                      ),
                                    ),
                                    const Text(
                                      "books name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
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


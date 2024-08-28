import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/screens/client_screens/all_lawyers_screens.dart';
import 'package:law_education_app/screens/client_screens/all_services_screen.dart';
import 'package:provider/provider.dart';

import '../../conts.dart';
import '../../provider/get_categories_provider.dart';
import 'all_services_reltedto_category_screen.dart';
import 'law_books_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final categoryProvider = Provider.of<CategoriesProvider>(context);

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
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
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
                          "My Jobs",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewAllMyJobs()));
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
                    //   color: whiteColor,
                    //   height: MediaQuery.of(context).size.height * 0.3,
                    //   child: FutureBuilder<List<Map<String, dynamic>>>(
                    //     future: myJobsCheckController.myJobCheckMethod(context: context),
                    //     builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    //       if (snapshot.connectionState == ConnectionState.waiting) {
                    //         return Center(child: CircularProgressIndicator());
                    //       } else if (snapshot.hasError) {
                    //         return Center(
                    //           child: Text(
                    //             'Error: ${snapshot.error}',
                    //             style: TextStyle(color: Colors.red, fontSize: 16),
                    //           ),
                    //         );
                    //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    //         return Center(
                    //           child: Text(
                    //             'You have not created any job',
                    //             style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    //           ),
                    //         );
                    //       } else {
                    //         final List<Map<String, dynamic>> myJobs = snapshot.data!;
                    //
                    //         return ListView.builder(
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: myJobs.length,
                    //           itemBuilder: (context, index) {
                    //             final Timestamp timestamp = myJobs[index]['createdOn'] as Timestamp;
                    //             final DateTime dateTime = timestamp.toDate();
                    //             final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
                    //
                    //             return Container(
                    //               color: whiteColor,
                    //               width: MediaQuery.of(context).size.width * 0.6,
                    //               margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    //               child: Card(
                    //                 color: whiteColor,
                    //                 elevation: 8.0,
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(10.0),
                    //                 ),
                    //                 child: Padding(
                    //                   padding: EdgeInsets.all(16.0),
                    //                   child: Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(
                    //                         'Created on: $formattedDate',
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.bold,
                    //                           fontSize: 16,
                    //                         ),
                    //                       ),
                    //                       SizedBox(height: 8.0),
                    //                       Text(
                    //                         myJobs[index]['title'] ?? 'No Title',
                    //                         style: TextStyle(
                    //                           fontSize: 18,
                    //                           fontWeight: FontWeight.w600,
                    //                         ),
                    //                       ),
                    //                       SizedBox(height: 4.0),
                    //                       Text(
                    //                         myJobs[index]['description'] ?? 'No Description',
                    //                         style: TextStyle(
                    //                           fontSize: 14,
                    //                           color: Colors.grey[700],
                    //                         ),
                    //                       ),
                    //                       SizedBox(height: 8.0),
                    //                       Text(
                    //                         '\$${myJobs[index]['price'] ?? '0.00'}',
                    //                         style: TextStyle(
                    //                           fontSize: 16,
                    //                           color: Colors.green,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             );
                    //           },
                    //         );
                    //       }
                    //     },
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
                          "Services",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AllServicesScreen()));
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllServicesRelatedToCategory(
                                                categoryName: categoryProvider
                                                    .categoriesList[index])));
                              },
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
                          "Lawyers",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AllLawyersScreens()));
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Placeholder(
                                      fallbackHeight: screenHeight * 0.12,
                                      fallbackWidth: screenWidth * 0.2,
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ),
                                    const Text(
                                      "Criminal",
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LawBooks()));
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
                                              color: lightGreyColor, width: 1)),
                                      child: const Center(
                                        child:
                                            Icon(Icons.miscellaneous_services),
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

class ViewAllMyJobs extends StatefulWidget {
  ViewAllMyJobs({super.key});

  @override
  State<ViewAllMyJobs> createState() => _ViewAllMyJobsState();
}

class _ViewAllMyJobsState extends State<ViewAllMyJobs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      height: MediaQuery.of(context).size.height * 0.3,
//       child: FutureBuilder<List<Map<String, dynamic>>>(
// future: MyJobsCheckController().myJobCheckMethod(context: context),
//         builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text(
//                 'You have not created any job',
//                 style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
//               ),
//             );
//           } else {
//             final List<Map<String, dynamic>> myJobs = snapshot.data!;
//
//             return ListView.builder(
//               scrollDirection: Axis.vertical,
//               itemCount: myJobs.length,
//               itemBuilder: (context, index) {
//                 final Timestamp timestamp = myJobs[index]['createdOn'] as Timestamp;
//                 final DateTime dateTime = timestamp.toDate();
//                 final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
//
//                 return Container(
//                   color: whiteColor,
//                   width: MediaQuery.of(context).size.width * 0.6,
//                   margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//                   child: Card(
//                     color: whiteColor,
//                     elevation: 8.0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Created on: $formattedDate',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(height: 8.0),
//                           Text(
//                             myJobs[index]['title'] ?? 'No Title',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(height: 4.0),
//                           Text(
//                             myJobs[index]['description'] ?? 'No Description',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                           SizedBox(height: 8.0),
//                           Text(
//                             '\$${myJobs[index]['price'] ?? '0.00'}',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.green,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
    );
  }
}

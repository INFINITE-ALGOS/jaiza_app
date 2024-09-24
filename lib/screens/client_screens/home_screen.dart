import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:law_education_app/controllers/general+admin_task.dart';
import 'package:law_education_app/provider/get_lawyers_provider.dart';
import 'package:law_education_app/screens/client_screens/all_lawyers_screens.dart';
import 'package:law_education_app/screens/client_screens/all_services_screen.dart';
import 'package:law_education_app/screens/client_screens/pdf_viewer_screen.dart';
import 'package:law_education_app/screens/client_screens/see_lawyer_profile.dart';
import 'package:law_education_app/widgets/crousel_slider.dart';
import 'package:provider/provider.dart';

import '../../controllers/book_controller.dart';
import '../../conts.dart';
import '../../models/book_model.dart';
import '../../provider/general_provider.dart';
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
  List<Map<String,dynamic>> initialLawyers=[];


  final bookController = BookController(); // Instance of BookController.

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final lawyerProvider = Provider.of<GetLawyersProvider>(context);
    initialLawyers=lawyerProvider.initialLawyers;

    final generalProvider = Provider.of<GeneralProvider>(context);
    final booksProvider = Provider.of<BookController>(context);
List<Map<String,dynamic>> books=booksProvider.books;
    List<String> crouselUrls=generalProvider.crouselUrlList ;
//print(initialLawyers);
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
                    InkWell(
                      child: Icon(
                        CupertinoIcons.location,
                        color: greyColor,
                      ),
                      onTap:(){
                       // print(FirebaseAuth.instance.currentUser!.uid);
                       // GeneralAdmiinTaskController().getCategoriesUrl('general/categories/tax.jpg', 'tax');
                        //CrouserSliderController().fetchAndSaveUrls('general/crouselImages');
                      },
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
                        AppLocalizations.of(context)!.search,
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
              child: ImageCarousel(crouselUrls: crouselUrls as List<String>),
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
                    // Row(
                    //   children: [
                    //     const Text(
                    //       "My Jobs",
                    //       style: TextStyle(
                    //           fontSize: 21, fontWeight: FontWeight.bold),
                    //     ),
                    //     const Spacer(),
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => ViewAllMyJobs()));
                    //       },
                    //       child: const Text(
                    //         "View all >>",
                    //         style: TextStyle(
                    //             color: primaryColor, fontWeight: FontWeight.w600),
                    //       ),
                    //     )
                    //   ],
                    // ),
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
                         Text(
                          AppLocalizations.of(context)!.services,
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
                          child:  Text(
                            AppLocalizations.of(context)!.viewAllDoubleArrow,
                            style: TextStyle(
                                color: primaryColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: generalProvider.categoriesMap.length,
                          itemBuilder: (context, index) {
                            String key = generalProvider.categoriesMap.keys.elementAt(index);
                            Map<String, dynamic> category = generalProvider.categoriesMap[key];
                            final String url=category['url'];
                            final String name=category['name'];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllServicesRelatedToCategory(
                                                categoryName: name,url: url,),
                                    ));
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
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: lightGreyColor,
                                            width: 1,
                                          ),
                                          //shape: BoxShape.circle, // Makes the container circular
                                        ),
                                        clipBehavior: Clip.hardEdge, // Ensures the image is clipped to the circular border
                                        child: CachedNetworkImage(height: 100,width: double.infinity,imageUrl: url,
                                          placeholder: (context, url) => CupertinoActivityIndicator(),  // Loading widget
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          fit: BoxFit.cover,// Fallback when image not found
                                        )
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
                         Text(
                           AppLocalizations.of(context)!.lawyers,
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                         //  await Provider.of<GetLawyersProvider>(context).getAllLawyers();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AllLawyersScreens()));
                          },
                          child:  Text(
                            AppLocalizations.of(context)!.viewAllDoubleArrow,
                            style: TextStyle(
                                color: primaryColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.2,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: initialLawyers.length,
                          itemBuilder: (context, index) {
                            final lawyer=initialLawyers[index];
                            final String name=initialLawyers[index]['name'];
                            final String url=initialLawyers[index]['url'];

                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SeeLawyerProfile(lawyer: lawyer,)));
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
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: lightGreyColor,
                                              width: 1,
                                            ),
                                            //shape: BoxShape.circle, // Makes the container circular
                                          ),
                                          clipBehavior: Clip.hardEdge, // Ensures the image is clipped to the circular border
                                          child: CachedNetworkImage(height: 100,width: double.infinity,imageUrl: url,
                                            placeholder: (context, url) => CupertinoActivityIndicator(),  // Loading widget
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                            fit: BoxFit.cover,// Fallback when image not found
                                          )
                                      ),
                                      SizedBox(height: 6,),
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
        padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
        child: Column(
          children: [
            // Title Row with 'View all' button
            Row(
              children: [
                 Text(
                  AppLocalizations.of(context)!.lawBooks,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LawBooks()));
                  },
                  child:  Text(
                    AppLocalizations.of(context)!.viewAllDoubleArrow,
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),

            SizedBox(
                    height: screenHeight * 0.25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewerScreen(
                                  fileUrl: book['fileUrl'],
                                  title: book['title'],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, right: 15),
                            child: Column(
                              children: [
                                Container(
                                  height: screenHeight * 0.12,
                                  width: screenWidth * 0.24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: lightGreyColor, width: 1),
                                  ),
                                  child: Image.network(
                                    book['cover'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  book['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

            ),
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
}


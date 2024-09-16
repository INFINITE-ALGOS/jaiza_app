import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:law_education_app/controllers/my_services_check_controller.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/lawyer_screens/alljobs_realtedto_category.dart';
import 'package:law_education_app/screens/lawyer_screens/pdf_viewer_screen_lawyer.dart';
import 'package:provider/provider.dart';
import '../../controllers/book_controller.dart';
import '../../conts.dart';
import '../../provider/general_provider.dart';
import '../../widgets/crousel_slider.dart';
import '../../models/books_model.dart';
import '../client_screens/law_books_screen.dart';
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
  Future<List<Books>>? books;
  final bookCon = BookController();
  @override
  void initState()
  {
    super.initState();
    books=bookCon.fetchBooks();
  }
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<MyProfileProvider>(context);
    final generalProvider = Provider.of<GeneralProvider>(context);
    List<String> crouselUrls = generalProvider.crouselUrlList;
    final profileData = profileProvider.profileData;

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (profileData == null || profileData['lawyerProfile'] == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show loading until profileData is fetched
        ),
      );
    }

    final List<dynamic> selectedCategories = profileData['lawyerProfile']['expertise'] ?? [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
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
                    Icon(CupertinoIcons.bell),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
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
                        "Search",
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
              child: ImageCarousel(crouselUrls: crouselUrls),
            ),
            SizedBox(height: screenHeight * 0.01),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
            ),
            Container(height: screenHeight * 0.01, color: lightGreyColor),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Jobs",
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AllJobsScreen()),
                            );
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
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
                          String key = generalProvider.categoriesMap.keys.elementAt(index);
                          Map<String, dynamic> category = generalProvider.categoriesMap[key];
                          final String url = category['url'];
                          final String name = category['name'];

                          // Check if the category name is in the selectedCategories list
                          if (selectedCategories.contains(name)) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllJobsRelatedToCategory(name: name, url: url),
                                  ),
                                );
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
                                        style: const TextStyle(fontWeight: FontWeight.w600),
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
              padding: EdgeInsets.only(top: screenHeight * 0.005, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Clients",
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AllClientsScreen()),
                            );
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: screenHeight * 0.25,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 25, top: 15),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Placeholder(
                                      fallbackHeight: screenHeight * 0.12,
                                      fallbackWidth: screenWidth * 0.2,
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    const Text(
                                      "name",
                                      style: TextStyle(fontWeight: FontWeight.w600),
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
            Container(height: screenHeight * 0.01, color: lightGreyColor),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Law Books",
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LawBooksLawyer()),
                            );
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
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
                              padding: const EdgeInsets.only(top: 15, right: 15),
                              child: Container(
                                child: Column(
                                  children: [
                                    Placeholder(
                                      fallbackHeight: screenHeight * 0.12,
                                      fallbackWidth: screenWidth * 0.28,
                                    ),
                                    Text(
                                      "Book Title",
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    FutureBuilder<List<Books>>(
                      future: books,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No books available.'));
                        }
                        return Container(
                          height: screenHeight * 0.22,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final book = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 15, right: 15),
                                child: Container(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: ()
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PdfViewerScreenLawyer(fileUrl: book.fileUrl, title:book.title,),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: screenHeight * 0.12,
                                          width: screenWidth * 0.24,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: lightGreyColor, width: 1),
                                          ),
                                          child:  Center(
                                            child: Image.network(book.cover,fit: BoxFit.cover,), // Show icon instead of cover image
                                          ),
                                        ),
                                      ),
                                      Text(
                                        book.title, // Display book title
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 50,),
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


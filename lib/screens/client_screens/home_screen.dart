import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/provider/get_lawyers_provider.dart';
import 'package:law_education_app/screens/client_screens/all_lawyers_screens.dart';
import 'package:law_education_app/screens/client_screens/all_services_screen.dart';
import 'package:law_education_app/screens/client_screens/see_lawyer_profile.dart';
import 'package:law_education_app/widgets/crousel_slider.dart';
import 'package:law_education_app/screens/client_screens/pdf_viewer_screen.dart';
import 'package:provider/provider.dart';
import '../../controllers/book_controller.dart';
import '../../conts.dart';
import '../../provider/general_provider.dart';
import '../../models/books_model.dart';
import 'all_services_reltedto_category_screen.dart';
import 'law_books_screen.dart';
import '../../controllers/book_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  List<Map<String,dynamic>> initialLawyers=[];
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
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final lawyerProvider = Provider.of<GetLawyersProvider>(context);
    initialLawyers=lawyerProvider.initialLawyers;

    final generalProvider = Provider.of<GeneralProvider>(context);
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
                                color: primaryColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
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
                        const Text(
                          "Lawyers",
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
                          child: const Text(
                            "View all >>",
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
                                    builder: (context) =>  LawBooks()));
                          },
                          child: const Text(
                            "View all >>",
                            style: TextStyle(
                                color: primaryColor, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
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
                                              builder: (context) => PdfViewerScreen(fileUrl: book.fileUrl, title:book.title,),
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
    );
  }
}

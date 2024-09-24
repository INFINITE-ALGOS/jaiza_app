import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/pdf_viewer_screen.dart';
import 'package:provider/provider.dart';
import '../../controllers/book_controller.dart';
import '../../models/book_model.dart';

class LawBooks extends StatefulWidget {
  const LawBooks({super.key});

  @override
  State<LawBooks> createState() => _LawBooksState();
}

class _LawBooksState extends State<LawBooks> {
  double screenHeight = 0;
  double screenWidth = 0;
  List<Map<String, dynamic>> allDocuments=[];
  List<Map<String, dynamic>> filteredDocuments=[];
  bool hasResult=true;
  // This declares a variable books that will hold the future result of fetching a list of Books

  final bookController = BookController(); //This creates an instance of BookController.
  TextEditingController searchController = TextEditingController();

  void filterDocuments() {
    String searchTerm = searchController.text.toLowerCase();

    setState(() {
      filteredDocuments = allDocuments.where((document) {
        final title = document['title'].toLowerCase();
        final titleMatches = title.contains(searchTerm);

        return titleMatches;
      }).toList();
      if(filteredDocuments.isEmpty){
        hasResult=false;
      }
    });
  }


  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lawBooksProvider = Provider.of<BookController>(context, listen: false);
   allDocuments=lawBooksProvider.books;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Law Books'),
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.03, right: 20, left: 20),
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
                        hintText: "Search by title or description ...",
                        border: InputBorder.none,
                        icon: const Icon(CupertinoIcons.search, color: greyColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // FutureBuilder to fetch and display books
            Expanded(
              child: () {
                if (allDocuments.isEmpty) {
                  return const Center(
                    child: Text(
                      "No current Books found",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  if (filteredDocuments.isEmpty && hasResult == true) {
                    filteredDocuments = allDocuments;
                    return _buildGridView(); // Initially, show all documents
                  }
                  if (filteredDocuments.isEmpty && hasResult == false) {
                    return const Center(
                      child: Text("No matching result found"),
                    );
                  } else {
                    return _buildGridView(); // Show filtered documents
                  }
                }
              }(),
            ),


          ],
        ),
      ),
    );
  }
  Widget _buildGridView(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
        ),
        itemCount: filteredDocuments.length,
        itemBuilder: (context, index) {
          final book = filteredDocuments[index];
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
            child: GridTile(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(
                    book['cover'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              footer: GridTileBar(
                backgroundColor: primaryColor,
                title: Text(
                  book['title'],
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/pdf_viewer_screen.dart';
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

  // This declares a variable books that will hold the future result of fetching a list of Books
  Future<List<Books>>? books;

  final bookController = BookController(); //This creates an instance of BookController.

  @override
  void initState() {
    super.initState();
    books = bookController.fetchBooks(); // Calls the fetchBooks method to get the list of books.
  }

  @override
  Widget build(BuildContext context) {
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

            // FutureBuilder to fetch and display books
            Expanded(
              child: FutureBuilder<List<Books>>(
                future: books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No books found'));
                  } else {
                    final books = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewerScreen(
                                    fileUrl: book.fileUrl,
                                    title: book.title,
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
                                    book.cover,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              footer: GridTileBar(
                                backgroundColor: primaryColor,
                                title: Text(
                                  book.title,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

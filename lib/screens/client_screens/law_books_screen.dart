import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/client_screens/pdf_viewer_screen.dart';
import '../../controllers/book_controller.dart';
import '../../models/books_model.dart';

class LawBooks extends StatefulWidget {
  @override
  _LawBooksState createState() => _LawBooksState();
}

class _LawBooksState extends State<LawBooks> {
  // This declares a variable books that will hold the future result of fetching a list of Books
  // from the server. The Future type is used for asynchronous operations.
  Future<List<Books>>? books;

  final bookController = BookController(); //This creates an instance of BookController,
  @override
  void initState() {
    super.initState();
    //books = bookController.fetchBooks();: Calls the fetchBooks method from BookController to fetch
    // the list of books and stores it in the books variable.(list define above)
    books = bookController.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Law Books'),
        backgroundColor: primaryColor,
      ),
      body:
      //The FutureBuilder widget is used to handle asynchronous operations in Flutter, such as
      // fetching data from a server. It helps you build your UI based on the current state of a
      // Future
      //This means that FutureBuilder is expecting a Future that will eventually give us a list of Books.
      FutureBuilder<List<Books>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found'));
          } else {
            final books = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(left: 20,right: 20 ,top: 30),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          builder: (context) => PdfViewerScreen(fileUrl: book.fileUrl,title: book.title),
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
                          child: Center(child:Image.network(book.cover,fit: BoxFit.cover,)),
                        ),
                      ),
                      footer: GridTileBar(
                        backgroundColor: primaryColor,
                        title: Text(book.title, textAlign: TextAlign.center),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
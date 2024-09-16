import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/books_model.dart';

class BookController
{
  Future<List<Books>> fetchBooks() async
  {
    final firestore = FirebaseFirestore.instance;
    final booksCollection = firestore.collection("books");
    final quarrySnapshot = await booksCollection.get();
    return quarrySnapshot.docs.map((doc)
    {
      final data = doc.data();
      return Books(
        title:data['title'],
        fileUrl: data['fileUrl'],
        cover: data['cover']
      );
    }).toList();
  }
}
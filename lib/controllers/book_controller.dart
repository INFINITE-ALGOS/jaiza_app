import 'package:cloud_firestore/cloud_firestore.dart';




class BookController
{
  List<Map<String,dynamic>> books=[];
  Future<void> fetchBooks() async
  {
    final firestore = FirebaseFirestore.instance;
    final booksCollection = firestore.collection("books");
    final quarrySnapshot = await booksCollection.get();
    books= quarrySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
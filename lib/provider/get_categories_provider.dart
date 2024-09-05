import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CategoriesProvider  {
   List<dynamic> categoriesList=[];
  Future<void> getCategories()async{
  DocumentSnapshot<Map<String,dynamic>> documentSnapshot=await FirebaseFirestore.instance.collection('categories').doc('categories').get();
  Map<String,dynamic> documentSnapshotData=documentSnapshot.data()!;
  categoriesList=documentSnapshotData['categories'];
  }
}
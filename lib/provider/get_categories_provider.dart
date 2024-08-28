import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesProvider {
   List categoriesList=[];
  Future<void> getCategories()async{
  DocumentSnapshot<Map<String,dynamic>> documentSnapshot=await FirebaseFirestore.instance.collection('categories').doc('categories').get();
  Map<String,dynamic> documentSnapshotData=documentSnapshot.data()!;
  categoriesList=documentSnapshotData['categories'];
  }
}
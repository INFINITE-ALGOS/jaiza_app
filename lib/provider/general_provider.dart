import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class GeneralProvider  {
   List<dynamic> categoriesNameList=[];
   List<String> crouselUrlList=[];
   Map<String,dynamic> categoriesMap={};
  // Future<void> getCategories()async{
  // DocumentSnapshot<Map<String,dynamic>> documentSnapshot=await FirebaseFirestore.instance.collection('general').doc('categories').get();
  // Map<String,dynamic> documentSnapshotData=documentSnapshot.data()!;
  // categoriesList=documentSnapshotData['categories'];
  // }
   Future<void> getCategories() async {
     categoriesNameList=[];
     try {
       // Fetch the document from Firestore
       DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
       await FirebaseFirestore.instance.collection('general').doc('categories').get();

       // Extract data from the document
       Map<String, dynamic>? documentSnapshotData = documentSnapshot.data();

       // Ensure we have data and proceed
       if (documentSnapshotData != null) {
     categoriesMap=Map<String,dynamic>.from(documentSnapshotData);
         documentSnapshotData.forEach((key, value) {
           if (value is Map<String, dynamic>) {
             // Extract the name if it exists
             String name = value['name'] as String? ?? '';
             if (name.isNotEmpty) {
               categoriesNameList.add(name);
             }
           }
         });

       }
     } catch (e) {
       print('Error fetching category names: $e');
     }
   }

   Future<void> getCrouselUrls() async {
     try {
       FirebaseFirestore firestore = FirebaseFirestore.instance;
       DocumentSnapshot docSnapshot = await firestore.collection('general').doc('crouselImages').get();

       if (docSnapshot.exists) {
         List<dynamic> dynamicUrls = docSnapshot['urls'];

         // Convert List<dynamic> to List<String>
         List<String> crouselUrls = List<String>.from(dynamicUrls);
         crouselUrlList=crouselUrls;
         // Now you can use the crouselUrls list in your app
       }
     } catch (e) {
       print('Error fetching URLs: $e');
     }
   }
}
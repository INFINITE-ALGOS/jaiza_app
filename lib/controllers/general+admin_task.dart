import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GeneralAdmiinTaskController{
  Future<List<String>> getFileUrlsFromFirebaseStorage(String folderPath) async {
    try {
      // Get a reference to the folder in Firebase Storage
      firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref(folderPath).listAll();

      // Create an empty list to store URLs
      List<String> urls = [];

      // Iterate through each item (file) in the folder and get the download URL
      for (var ref in result.items) {
        String downloadUrl = await ref.getDownloadURL();
        urls.add(downloadUrl); // Add URL to the list
      }

      return urls; // Return the list of URLs
    } catch (e) {
      print('Error fetching file URLs: $e');
      return [];
    }
  }

  Future<void> saveUrlsToFirestore(List<String> urls) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Update the 'urls' array in the 'crouselImages' document by adding new URLs
      await firestore.collection('general').doc('crouselImages').update({
        'urls': FieldValue.arrayUnion(urls),
      });

      print('URLs saved to Firestore successfully');
    } catch (e) {
      print('Error saving URLs to Firestore: $e');
    }
  }
  Future<void> fetchAndSaveUrls(String folderPath) async {
    // Step 1: Get the URLs from Firebase Storage
    List<String> urls = await getFileUrlsFromFirebaseStorage(folderPath);

    // Step 2: Save the URLs to Firestore
    if (urls.isNotEmpty) {
      await saveUrlsToFirestore(urls);
    } else {
      print('No URLs to save');
    }
  }



  Future<void> getCategoriesUrl(String storagePath, String documentField) async {
    try {
      // Get the file's download URL from Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      final url = await storageRef.getDownloadURL();

      // Update the Firestore document with the URL
      final firestore = FirebaseFirestore.instance;
      final categoriesRef = firestore.collection('general').doc('categories');
      await categoriesRef.update({
        '$documentField.url':url
      });

      print('Firestore updated with the file URL successfully!');
    } catch (e) {
      print('Error: $e');
    }
  }



}
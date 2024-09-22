import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckAlreadyServiceBuy{
  final firestore= FirebaseFirestore.instance;
  Future<Map<String,dynamic>> checkAlreadyService(String lawyerId, String serviceId) async {
    try {
      // Get the current user's UID
      String clientId = FirebaseAuth.instance.currentUser!.uid;

      // Query Firestore to check if a document exists with both the clientId and lawyerId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('clientId', isEqualTo: clientId)
          .where('lawyerId', isEqualTo: lawyerId)
      .where('serviceId',isEqualTo: serviceId)
          .limit(1) // Limit to 1 to improve performance
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Return the first document's data as a Map
        Map<String, dynamic> requestData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return requestData;

      } else {
        return {}; // Return an empty map if no document is found
      }

      // If the query finds a document, return true; otherwise, return false

    } catch (e) {
      //print('Error checking service request: $e');
      return {}; // In case of an error, assume the document doesn't exist
    }
  }
  Future<Map<String,dynamic>> checkAlreadyJobBuy(String clientId, String jobId) async {
    try {
      // Get the current user's UID
      String lawyerId = FirebaseAuth.instance.currentUser!.uid;

      // Query Firestore to check if a document exists with both the clientId and lawyerId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('offers')
          .where('lawyerId', isEqualTo: lawyerId)
          .where('clientId', isEqualTo: clientId)
          .where('jobId',isEqualTo: jobId)
          .limit(1) // Limit to 1 to improve performance
          .get();

      // If the query finds a document, return true; otherwise, return false
      if (querySnapshot.docs.isNotEmpty) {
        // Return the first document's data as a Map
        Map<String, dynamic> requestData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return requestData;

      } else {
        return {}; }}
    catch (e) {
      //print('Error checking service request: $e');
      return {}; // In case of an error, assume the document doesn't exist
    }
  }

}
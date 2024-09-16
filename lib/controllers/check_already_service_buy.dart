import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckAlreadyServiceBuy{
  final firestore= FirebaseFirestore.instance;
  Future<bool> checkAlreadyService(String lawyerId, String serviceId) async {
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

      // If the query finds a document, return true; otherwise, return false
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      //print('Error checking service request: $e');
      return false; // In case of an error, assume the document doesn't exist
    }
  }
  Future<bool> checkAlreadyJobBuy(String clientId, String jobId) async {
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
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      //print('Error checking service request: $e');
      return false; // In case of an error, assume the document doesn't exist
    }
  }

}
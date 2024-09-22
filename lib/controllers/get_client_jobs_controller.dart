import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';

class GetClientJobsController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getClientJobsWithDetails() async {
    // Fetch all jobs from 'jobs' collection
    final jobSnapshot = await _firestore.collection('jobs').get();

    List<Map<String, dynamic>> combinedDataList = [];

    // Loop through each job document
    for (var jobDoc in jobSnapshot.docs) {
      var jobData = jobDoc.data();
      var clientId = jobData['clientId'];

      // Fetch client details from 'users' collection where 'id' matches 'clientId'
      final clientSnapshot = await _firestore.collection('users').doc(clientId).get();

      if (clientSnapshot.exists) {
        // Combine job data and client data into one map
        combinedDataList.add({
          'jobDetails': jobData,
          'clientDetails': clientSnapshot.data(),
        });
      }
    }

    return combinedDataList; // Return the list of combined data
  }
}

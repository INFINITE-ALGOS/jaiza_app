import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../utils/custom_snackbar.dart';

class MyJobsCheckController {
  Future<List<Map<String, dynamic>>> fetchJobsAndOffers(
      BuildContext context,
      List<String> jobStatuses, // Changed to a list of statuses
      List<String> offerStatus
      ) async {
    try {
      final List<Map<String, dynamic>> jobsWithOffersAndLawyers = [];
      final User currentUser = FirebaseAuth.instance.currentUser!;
      final uid = currentUser.uid;

      // Fetch jobs for the current user based on multiple job statuses
      final jobQuerySnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where("clientId", isEqualTo: uid)
          .where('status', whereIn: jobStatuses) // Query for multiple statuses
          .get();

      // Iterate through the jobs
      for (var jobDoc in jobQuerySnapshot.docs) {
        var jobData = jobDoc.data() as Map<String, dynamic>;
        String jobId = jobDoc.id; // Get the jobId

        // Fetch offers for this job
        final offersQuerySnapshot = await FirebaseFirestore.instance
            .collection('offers')
            .where('clientId', isEqualTo: uid)
            .where('status', whereIn:  offerStatus)
            .where('jobId', isEqualTo: jobId)
            .get();

        // List to store offers with lawyer details for this job
        List<Map<String, dynamic>> offersWithLawyers = [];

        // Iterate through the offers
        for (var offerDoc in offersQuerySnapshot.docs) {
          var offerData = offerDoc.data() as Map<String, dynamic>;
          String lawyerId = offerData['lawyerId'];

          // Fetch lawyer details
          DocumentSnapshot lawyerSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(lawyerId)
              .get();
          var lawyerData = lawyerSnapshot.data() as Map<String, dynamic>;

          // Combine offer and lawyer details
          offersWithLawyers.add({
            'offerDetails': offerData,
            'lawyerDetails': lawyerData,
          });
        }

        // Add the job with its offers and lawyer details to the list
        jobsWithOffersAndLawyers.add({
          'jobDetails': jobData,
          'offers': offersWithLawyers,
        });
      }
      return jobsWithOffersAndLawyers;
    } catch (e) {
      CustomSnackbar.showError(
          context: context,
          title: "Error",
          message: e.toString()
      );
      return [];
    }
  }

  Future<void> deleteJob(String jobId) async {
    await FirebaseFirestore.instance
        .collection('jobs')
        .doc(jobId)
        .delete();
  }
}

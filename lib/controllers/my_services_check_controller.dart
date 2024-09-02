import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../utils/custom_snackbar.dart';

class MyServicesCheckController {
  Future<List<Map<String, dynamic>>> fetchServicesAndRequests(
      BuildContext context,
      List<String> serviceStatuses, // Changed to a list of statuses
      List<String> requestStatus
      ) async {
    try {
      final List<Map<String, dynamic>> servicesWithRequestsAndClient = [];
      final User currentUser = FirebaseAuth.instance.currentUser!;
      final uid = currentUser.uid;

      // Fetch jobs for the current user based on multiple job statuses
      final serviceQuerySnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where("lawyerId", isEqualTo: uid)
          .where('status', whereIn: serviceStatuses) // Query for multiple statuses
          .get();

      // Iterate through the jobs
      for (var serviceDoc in serviceQuerySnapshot.docs) {
        var serviceData = serviceDoc.data() as Map<String, dynamic>;
        String serviceId = serviceDoc.id; // Get the jobId

        // Fetch offers for this job
        final requestsQuerySnapshot = await FirebaseFirestore.instance
            .collection('requests')
            .where('lawyerId', isEqualTo: uid)
            .where('status', whereIn:  requestStatus)
            .where('serviceId', isEqualTo: serviceId)
            .get();

        // List to store offers with lawyer details for this job
        List<Map<String, dynamic>> requestsWithClients = [];

        // Iterate through the offers
        for (var requestDoc in requestsQuerySnapshot.docs) {
          var requestData = requestDoc.data() as Map<String, dynamic>;
          String clientId = requestData['clientId'];

          // Fetch lawyer details
          DocumentSnapshot clientSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(clientId)
              .get();
          var clientData = clientSnapshot.data() as Map<String, dynamic>;

          // Combine offer and lawyer details
          requestsWithClients.add({
            'requestDetails': requestData,
            'clientDetails': clientData,
          });
        }

        // Add the job with its offers and lawyer details to the list
        servicesWithRequestsAndClient.add({
          'serviceDetails': serviceData,
          'requests': requestsWithClients,
        });
      }
      return servicesWithRequestsAndClient;
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

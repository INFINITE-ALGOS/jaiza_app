import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';

class GetLawyerServicesController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllServicesWithLawyerDetails() async {
    // Fetch all services from 'services' collection
    final serviceSnapshot = await FirebaseFirestore.instance.collection('services').get();

    List<Map<String, dynamic>> combinedDataList = [];

    // Loop through each service document
    for (var serviceDoc in serviceSnapshot.docs) {
      var serviceData = serviceDoc.data();
      var lawyerId = serviceData['lawyerId'];

      // Fetch lawyer details from 'users' collection where 'id' matches 'lawyerId'
      final lawyerSnapshot = await FirebaseFirestore.instance.collection('users').doc(lawyerId).get();

      if (lawyerSnapshot.exists) {
        // Combine service data and lawyer data into one map
        combinedDataList.add({
          'serviceDetails': serviceData,
          'lawyerDetails': lawyerSnapshot.data(),
        });
      }
    }

    return combinedDataList; // Return the list of combined data
  }
}

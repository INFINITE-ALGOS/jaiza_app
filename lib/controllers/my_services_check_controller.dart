import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';

class MyServicesCheckController {
  Future<List<Map<String, dynamic>>> myServicesCheckMethod({required BuildContext context}) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where("lawyerId", isEqualTo: uid)
          .where('serviceStatus', isEqualTo: 'active')
          .get();

      // Check if there are documents and return the data
      if (querySnapshot.docs.isEmpty) {
        return []; // Return an empty list if no jobs found
      }

      // Convert documents to a list of maps
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } on FirebaseException catch (e) {
      CustomSnackbar.showError(
        context: context,
        title: "Error",
        message: e.toString(),
      );
      return []; // Return an empty list in case of an error
    } catch (e) {
      CustomSnackbar.showError(
        context: context,
        title: "Error",
        message: e.toString(),
      );
      return []; // Return an empty list in case of a non-Firebase error
    }
  }
}

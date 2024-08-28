import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';

class GetLawyerServicesController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getLawyerServicesMethod() async {
    try {
      return await _firestore.collection("services").get();
    } on FirebaseException catch (e) {
      rethrow;    }
    catch (e) {
      rethrow;          // You can choose to rethrow or handle the error as needed
    }
  }
}

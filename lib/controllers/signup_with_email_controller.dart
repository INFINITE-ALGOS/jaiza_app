import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/models/client_model.dart';
import 'package:law_education_app/models/lawyer_model.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';
import 'package:law_education_app/widgets/custom_scaffold_messanger.dart';

class SignupWithEmailController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Method to sign up a client with email
  Future<void> clientSignUpWithEmailMethod({
    required BuildContext context,
    required String userName,
    required String userEmail,
    required String userPassword,
    required String selectedRole,
    required String userType,
    required String userAddress,
    required String userPhoneNo,
    required String url,
  }) async {
    if (userType == 'client') {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
        await userCredential.user!.sendEmailVerification();
        User user = userCredential.user!;

      //  print("Client URL: $url"); // Debug print

        ClientModel clientModel = ClientModel(
          name: userName,
          id: user.uid,
          email: userEmail,
          phone: userPhoneNo,
          isActive: true,
          createdOn: DateTime.now(),
          rating: '0.0',
          type: selectedRole,
          isVerified: false,
          url: url, // Check if this is null
          address: userAddress,
        );

        await _firestore.collection("users").doc(user.uid).set(clientModel.toMap());

        // Navigate to the login screen after successful signup
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        print("Error: ${e.toString()}"); // Debug print
        if (context.mounted) {
          CustomScaffoldSnackbar.showSnackbar(
            context,
            e.toString(),
            backgroundColor: redColor,
          );
        }
      }
    }
  }

  /// Method to sign up a lawyer with email
  Future<void> lawyerSignUpWithEmailMethod({
    required BuildContext context,
    required String userName,
    required String userEmail,
    required String userPassword,
    required String selectedRole,
    required String userType,
    required String userAddress,
    required String userPhoneNo,
    required String bio,
    required String designation,
    required String selectedExperience,
    required List selectedExpertise,
    required String url,
    required List<Map<String, dynamic>> portfolio,
  }) async {
    if (userType == 'lawyer') {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
        await userCredential.user!.sendEmailVerification();
        User user = userCredential.user!;

        LawyerModel lawyerModel = LawyerModel(
          id: user.uid,
          name: userName,
          email: userEmail,
          address: userAddress,
          phone: userPhoneNo,
          isActive: true,
          createdOn: DateTime.now(),
          rating: '0.0',
          portfolio: portfolio,
          lawyerProfile: {
            'bio': bio,
            'designation': designation,
            'experience': selectedExperience,
            'expertise': selectedExpertise,
          },
          isVerified: false,
          type: 'lawyer',
          url: url,
        );

        await _firestore.collection("users").doc(user.uid).set(lawyerModel.toMap());
        print("danish yes");
        // Navigate to the login screen after successful signup
        if (context.mounted) {
          print("danish");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        // General error handling
        if (context.mounted) {
          print("danish no");
          CustomScaffoldSnackbar.showSnackbar(
            context,
            e.toString(),
            backgroundColor: redColor,
          );
        }
      }
    }
  }
}

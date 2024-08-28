import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/models/client_model.dart';
import 'package:law_education_app/models/lawyer_model.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';
import '../screens/client_screens/bottom_nav.dart';
import '../screens/lawyer_screens/bottom_navigation_bar.dart';
class SignupWithEmailController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> signUpWithEmailMethod({
    required BuildContext context,
    required String userName,
    required String userEmail,
    required String userPassword,
    required String selectedRole,
    required String userType
  }) async {
    if(userType=='client'){
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
        await userCredential.user!.sendEmailVerification();
        User user = userCredential.user!;
        ClientModel clientModel=ClientModel(name: userName,
            email: userEmail,
            phone: "",
            isActive: true,
            createdOn: DateTime.now(),
            rating: '',
            type: selectedRole,
            isVerified: false);
        await _firestore.collection("users").doc(user.uid).set(clientModel.toMap());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      } on FirebaseException catch (e) {
        CustomSnackbar.showError(
          context: context,
          title: "Error",
          message: e.message ?? "An unexpected error occurred.",
        );
      } catch (e) {
        CustomSnackbar.showError(
          context: context,
          title: "Error",
          message: e.toString(),
        );
      }
    }
    else if(userType=='lawyer'){
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
        await userCredential.user!.sendEmailVerification();
        User user = userCredential.user!;
        LawyerModel lawyerModel=LawyerModel(name: userName,
            email: userEmail,
            phone: "",
            isActive: true,
            type: selectedRole,
            createdOn: DateTime.now(),
            rating: '0.0',
            experience: 0,
            isVerified: false);
        await _firestore.collection("users").doc(user.uid).set(lawyerModel.toMap());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      } on FirebaseException catch (e) {
        CustomSnackbar.showError(
          title: "Error",
          message: e.message ?? "An unexpected error occurred.", context: context,
        );
      } catch (e) {
        CustomSnackbar.showError(
          context: context,
          title: "Error",
          message: e.toString(),
        );
      }
    }
  }
}




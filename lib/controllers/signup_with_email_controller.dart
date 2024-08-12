import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Import for BuildContext
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/models/user_model.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/screens/client_screens/home_screen.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';

class SignupWithEmailController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpWithEmailMethod({
    required BuildContext context,
    required String userName,
    required String userEmail,
    required String userPassword,
  }) async {
    EasyLoading.show(status: "Please wait");
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      User user = userCredential.user!;
      user.sendEmailVerification();

      UserModel userModel = UserModel(
        uId: user.uid,
        username: userName,
        email: userEmail,
        phone: '',
        isActive: true,
        createdOn: DateTime.now(),
        isVerified: false,
        userType: 'client',
      );

      await _firestore.collection("users").doc(user.uid).set(userModel.toMap());
      EasyLoading.dismiss();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
CustomSnackbar.showSuccess(context: context, title: "Success", message: "Now please verify your email");
      // Optionally show success message or handle post-registration logic
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      CustomSnackbar.showError(
        context: context,
        title: "Error",
        message: e.message ?? "An unexpected error occurred.",
      );
    } catch (e) {
      EasyLoading.dismiss();
      CustomSnackbar.showError(
        context: context,
        title: "Error",
        message: e.toString(),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Import for BuildContext
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/models/user_model.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/client_screens/home_screen.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';

class SigninWithEmailController{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future<void> signInWithEmailController({required String userEmail,required String userPassword,    required BuildContext context,
  })async{
    EasyLoading.show(status: "Please Wait");
    try{
  await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);
  await _firestore.collection("users").doc(_auth.currentUser!.uid).set({"isVerified":true});
  EasyLoading.dismiss();
  Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(builder: (context) => bottom_nav()),
        (Route<dynamic> route) => false,);
}
    on FirebaseException catch(e){
      EasyLoading.dismiss();
      CustomSnackbar.showError(
        context: context,
        title: "Error",
        message: e.message ?? "An unexpected error occurred.",
      );
    }
    catch(e){
      EasyLoading.dismiss();
      CustomSnackbar.showError(
        context: context,
        title: "Error",
        message: e.toString(),
      );
    }
  }
}
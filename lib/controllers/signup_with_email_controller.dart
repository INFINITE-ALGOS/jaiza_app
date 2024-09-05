
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/models/client_model.dart';
import 'package:law_education_app/models/lawyer_model.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';
import '../screens/client_screens/bottom_nav.dart';
import '../screens/lawyer_screens/bottom_navigation_bar.dart';
import '../utils/progress_dialog_widget.dart';
class SignupWithEmailController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    if(userType=='client'){
      try {
        ProgressDialogWidget.show(context,"Creating Profile");
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
        await userCredential.user!.sendEmailVerification();
        User user = userCredential.user!;
        ClientModel clientModel=ClientModel(name: userName,
            email: userEmail,
            phone: userPhoneNo,
            isActive: true,
            createdOn: DateTime.now(),
            rating: '0.0',
            type: selectedRole,
            isVerified: false,
            url: url,
            address: userAddress);
        await _firestore.collection("users").doc(user.uid).set(clientModel.toMap());
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      } on FirebaseException catch (e) {
        ProgressDialogWidget.hide(context);
        CustomSnackbar.showError(
          context: context,
          title: "Error",
          message: e.message ?? "An unexpected error occurred.",
        );
      } catch (e) {
        ProgressDialogWidget.hide(context);
        CustomSnackbar.showError(
          context: context,
          title: "Error",
          message: e.toString(),
        );
      }
    }
  }
  Future<void> lawyerSignUpWithEmailMethod({required BuildContext context,
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
    required List<Map<String,dynamic>> portfolio,
    })async{
     if(userType=='lawyer'){
    try {
    ProgressDialogWidget.show(context,"Creating Profile");
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
    email: userEmail,
    password: userPassword,
    );
    await userCredential.user!.sendEmailVerification();
    User user = userCredential.user!;
    final lawyerModel=LawyerModel(name: userName, email: userEmail, address: userAddress, phone: userPhoneNo, isActive: true, createdOn: DateTime.now(), rating: '0.0', portfolio: [],
    lawyerProfile: {
    'bio':bio,
    'designation':designation,
    'experience':selectedExperience,
    'expertise':selectedExpertise


    },
    isVerified: false, type: 'lawyer', url: url);

    await _firestore.collection("users").doc(user.uid).set(lawyerModel.toMap());
    //ProgressDialogWidget.hide(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    } on FirebaseException catch (e) {
    ProgressDialogWidget.hide(context);

    CustomSnackbar.showError(
    title: "Error",
    message: e.message ?? "An unexpected error occurred.", context: context,
    );
    } catch (e) {
    ProgressDialogWidget.hide(context);

    CustomSnackbar.showError(
    context: context,
    title: "Error",
    message: e.toString(),
    );
    }
    }
  }
}










import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/models/create_job_model.dart';

import '../screens/client_screens/bottom_nav.dart';
import '../utils/custom_snackbar.dart';

class CreateJobController{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future<void>createJobMethod({required String title,required String description,required price,required String location,required String category,required BuildContext context,required String duration})async{

    EasyLoading.show(status: "Please wait");
    try{
    DocumentReference docRef = _firestore.collection("jobs").doc();
    String docId = docRef.id;
    final CreateJobModel createJobModel=CreateJobModel(jobId: docId, clientId: _auth.currentUser!.uid, title: title, description: description, price: price, status: "pending", createdOn: DateTime.now(), category: category,location: location,duration:duration);

    await docRef.set(createJobModel.toMap());
    EasyLoading.dismiss();
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) =>  BottomNavigationbarClient(selectedIndex: 0,)),
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
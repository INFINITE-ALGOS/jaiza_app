import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/models/create_job_model.dart';
import 'package:law_education_app/models/create_service_model.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';

import '../screens/client_screens/bottom_nav.dart';
import '../utils/custom_snackbar.dart';

class CreateServiceController extends ChangeNotifier{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future<void>createServiceMethod({required String title,required String description,required price,required String location,required String category,required BuildContext context})async{

    EasyLoading.show(status: "Please wait");
    try{
      DocumentReference docRef = _firestore.collection("services").doc();
      String docId = docRef.id;
      final CreateServiceModel createServiceModel=CreateServiceModel(serviceId: docId, lawyerId: _auth.currentUser!.uid, title: title, description: description, price: price, status: "active", createdOn: DateTime.now(), category: category,location: location);

      await docRef.set(createServiceModel.toMap());
      EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => BottomNavigationLawyer()),
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
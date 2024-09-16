import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class MyProfileProvider extends ChangeNotifier {
  Map<String, dynamic> profileData = {};
  String? imageUrl;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final picker = ImagePicker();
  XFile? _image;

  Future<void> getProfileData() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get();
    profileData = doc.data()!;
  }

  Future<void> updateProfileData(Map<String, dynamic> updatedData) async {
    if (_auth.currentUser != null) {
      //  EasyLoading.show(status: "Please wait");
      await _firestore.collection("users").doc(_auth.currentUser!.uid).update(updatedData);
      await getProfileData();
      // EasyLoading.dismiss();
      notifyListeners();
    }
  }

}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/client_screens/bottom_nav.dart';
import '../screens/lawyer_screens/bottom_navigation_bar.dart';


class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Method to sign in user
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }
  // Method to get user type from Firestore
  Future<String?> getUserType(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        return userDoc.data()?['type'] as String?;
      } else {
        print('User document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching user type: $e');
      return null;
    }
  }
  // Method to handle login and role-based navigation
  Future<void> loginAndNavigate(String email, String password, BuildContext context) async {
    User? user = await signInWithEmailPassword(email, password);
    if (user != null) {
      String? userType = await getUserType(user.uid);
      _firestore.collection("users").doc(user.uid).update({"isVerified":true});
      if (userType == 'client') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationbarClient(selectedIndex: 0,)));
      } else if (userType == 'lawyer') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationLawyer()));
      } else {
        print('User type not found');
      }
    } else {
      print('Login failed');
    }
  }
}
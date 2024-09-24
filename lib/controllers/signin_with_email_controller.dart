
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/book_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/provider/get_clients_provider.dart';
import 'package:law_education_app/provider/get_lawyers_provider.dart';
import 'package:law_education_app/widgets/custom_scaffold_messanger.dart';
import 'package:provider/provider.dart';
import '../screens/client_screens/bottom_nav.dart';
import '../screens/lawyer_screens/bottom_navigation_bar.dart';
import '../provider/myprofile_controller.dart';


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
  // Method to handle login and role-based navigation
  Future<void> loginAndNavigate(String email, String password, BuildContext context) async {
    try{
     // User? currentUser = FirebaseAuth.instance.currentUser;
     // if(currentUser!.emailVerified){
        User? user = await signInWithEmailPassword(email, password);
        if(user==null){
          return CustomScaffoldSnackbar.showSnackbar(context, "No Account created by this email",backgroundColor: redColor);

        }
        if(user!=null){
          DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
              .collection('users')
              .doc(user.uid)
              .get();
          String userType = userDoc['type'];
          _firestore.collection("users").doc(user.uid).update({"isVerified":true});

            if (userType == 'client') {
              final lawyerProvider = Provider.of<GetLawyersProvider>(context, listen: false);
              final profileProvider = Provider.of<MyProfileProvider>(context, listen: false);
              final lawBooksProvider = Provider.of<BookController>(context, listen: false);
await lawBooksProvider.fetchBooks();
              await profileProvider.getProfileData();
              await lawyerProvider.getInitialLawyers();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigationbarClient(selectedIndex: 0,)),(Route route)=>false);
            }

            else if (userType == 'lawyer') {
              final clientProvider = Provider.of<GetClientsProvider>(context, listen: false);

              final profileProvider = Provider.of<MyProfileProvider>(context, listen: false);
              final lawBooksProvider = Provider.of<BookController>(context, listen: false);
              await lawBooksProvider.fetchBooks();
              await profileProvider.getProfileData();
              await clientProvider.getInitialClientss();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigationLawyer(selectedIndex: 0,)),(Route route)=>false);
            }
            else{
              return CustomScaffoldSnackbar.showSnackbar(context,"An unexpected error occur,please try again",backgroundColor: redColor);

            }


        }
   // }
      //else if(!currentUser!.emailVerified){
     //   return CustomScaffoldSnackbar.showSnackbar(context, "Please first verify your email",backgroundColor: redColor);
      //}
    }
    on FirebaseException catch(e){
      return CustomScaffoldSnackbar.showSnackbar(context, e.toString(),backgroundColor: redColor);

    }
    catch(e){
      return CustomScaffoldSnackbar.showSnackbar(context, e.toString(),backgroundColor: redColor);
    }
  }

}
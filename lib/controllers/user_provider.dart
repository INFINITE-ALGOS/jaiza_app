import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/models/client_model.dart';
import 'package:law_education_app/models/lawyer_model.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';

class UserProvider extends ChangeNotifier
{
  ClientModel? _clientModel;
  LawyerModel? _lawyerModel;
  bool _isAuthenticated= false;
  String? _role;

  ClientModel? get clientModelThroughProvider => _clientModel;
  LawyerModel? get lawyerModelThroughProvider => _lawyerModel;
  bool get isAuthenticated => _isAuthenticated;
  String? get role => _role;

  //will check user is login or authenticated then get its data or lead to login screen
  Future<void> getUserData(BuildContext context)async
  {
    final user = FirebaseAuth.instance.currentUser;
    print('Current user: $user');
    if(user!=null)
    {
      print('User is logged in.');
      final UserDoc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      print('User document exists: ${UserDoc.exists}');
      if(UserDoc.exists)
      {
        final data = UserDoc.data();
        print('User data: $data');
        _role = data!["type"].toString();
        print("role is $_role");

        if(_role?.trim()=="client")
        {
          _clientModel = ClientModel.fromMap(data);
        }
        else if(_role?.trim()=="lawyer")
        {
          _lawyerModel = LawyerModel.fromMap(data);
        }

        _isAuthenticated=true;
        notifyListeners();
        print(_role);

        if(_role?.trim()=="client")
        {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavigationbarClient(selectedIndex: 0,)));
        }
        else if(_role?.trim()=="lawyer")
        {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavigationLawyer(selectedIndex: 0,)));
        }
        else
        {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SignUpScreen()));
        }
      }
      //todo : if user doc doesnt exsisit
    }
  }
}
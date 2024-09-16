
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/user_provider.dart';
import 'package:law_education_app/conts.dart';
<<<<<<< Updated upstream
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';
=======
import 'package:law_education_app/screens/auth/signup_screen.dart';
>>>>>>> Stashed changes
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 3), (){
      checkUserStatus();
    });
    super.initState();
<<<<<<< Updated upstream

=======
    StartSplashScreen();
>>>>>>> Stashed changes
  }

  Future<void> StartSplashScreen() async
  {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool hasSeenBoardingScreen = sp.getBool("seenOnBoadingScreen")??false;

    if (FirebaseAuth.instance.currentUser == null) {
      if (!hasSeenBoardingScreen) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBooardingScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      }
    } else {
      checkUserStatus();
    }
  }


  Future<void> checkUserStatus() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // await userProvider.getUserData(context);
    if(FirebaseAuth.instance.currentUser==null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (Route route)=>false);
    }
    else {
      if (!currentUser!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route route) => false,
        );
      }
      else{final profileProvider=Provider.of<MyProfileProvider>(context,listen: false);
      await profileProvider.getProfileData();
      final Map<String,dynamic> profileData=profileProvider.profileData;
      if(profileData['type']=='lawyer'){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigationLawyer(selectedIndex: 0)), (Route route)=>false);
      }
      else if(profileData['type']=='client'){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigationbarClient(selectedIndex: 0)), (Route route)=>false);

      }}
    }

  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:primaryColor,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset('lib/assets/law_icon.png',scale: 3,),
              ),
              SizedBox(height: 30,),
              Text("JAIZA",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)
            ],
          ),
        )
    );
  }
}

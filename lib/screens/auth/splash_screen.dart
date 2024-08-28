
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/user_provider.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkUserStatus();
  }
  Future<void> checkUserStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        backgroundColor: blueColor,
        body: Center(
          child: Container(
            child: Text("Splash Screen"),
          ),
        )
    );
  }
}

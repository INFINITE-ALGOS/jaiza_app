import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: whiteColor),
      debugShowCheckedModeBanner: false,
      home: LogInScreen(),
      builder: EasyLoading.init(),     );
  }
}


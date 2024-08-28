import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/screens/auth/onboarding_1.dart';
import 'package:law_education_app/screens/auth/onboarding_screen.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/screens/auth/splash_screen.dart';
import 'package:provider/provider.dart';
import 'controllers/user_provider.dart';

//not working properly
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add more providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: whiteColor),
      debugShowCheckedModeBanner: false,
      home:SignUpScreen(),
    );
  }
}


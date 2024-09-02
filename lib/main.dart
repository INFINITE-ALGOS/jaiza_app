import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/controllers/create_job_controller.dart';
import 'package:law_education_app/provider/get_categories_provider.dart';
import 'package:law_education_app/provider/pdf_provider.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/screens/auth/splash_screen.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:law_education_app/provider/language_provider.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';

import 'controllers/my_jobs_check_contoller.dart';
import 'controllers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();


  // Initialize the LanguageProvider and load the saved locale
  final LanguageProvider languageProvider = LanguageProvider();
  await languageProvider.loadLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>PDFProvider()),
      //  Provider(create: (_)=>NavigationService()),
        Provider(create: (_)=>CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => languageProvider),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          locale: languageProvider.locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ur')],
          theme: ThemeData(scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
         // home: const BottomNavigationLawyer(),
       //home: BottomNavigationbarClient(selectedIndex: 0,),
      home: SignUpScreen(),
         //home: PdfTestScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

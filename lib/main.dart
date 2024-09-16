import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
<<<<<<< Updated upstream
import 'package:law_education_app/controllers/create_job_controller.dart';
import 'package:law_education_app/provider/get_lawyers_provider.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/provider/general_provider.dart';
import 'package:law_education_app/provider/pdf_provider.dart';
import 'package:law_education_app/screens/auth/login_screen.dart';
import 'package:law_education_app/screens/auth/onboarding_screen.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
=======
import 'package:law_education_app/provider/get_categories_provider.dart';
import 'package:law_education_app/provider/pdf_provider.dart';
>>>>>>> Stashed changes
import 'package:law_education_app/screens/auth/splash_screen.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/screens/lawyer_screens/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:law_education_app/provider/language_provider.dart';
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
        ChangeNotifierProvider(create: (_) => PDFProvider()),
        //  Provider(create: (_)=>NavigationService()),
        Provider(create: (_) => GeneralProvider()),
        Provider(create: (_)=>GetLawyersProvider()),
        ChangeNotifierProvider(create: (context) => languageProvider),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context)=>MyProfileProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<GeneralProvider>(context).getCategories();
    Provider.of<GeneralProvider>(context).getCrouselUrls();

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
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: primaryColor
              ),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                titleTextStyle: TextStyle(color: whiteColor,fontSize: 20),
                  color: primaryColor,
                  iconTheme: IconThemeData(color: whiteColor))),

          debugShowCheckedModeBanner: false,
<<<<<<< Updated upstream
          home: SplashScreen(),
=======
         // home:  BottomNavigationLawyer(selectedIndex: 0,),
       //home: BottomNavigationbarClient(selectedIndex: 0,),
          home: BottomNavigationLawyer(selectedIndex: 0,),
         //home: PdfTestScreen()
>>>>>>> Stashed changes
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

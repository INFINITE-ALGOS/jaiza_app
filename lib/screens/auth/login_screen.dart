import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/login_controller.dart';
import 'package:law_education_app/controllers/myprofile_controller.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';

import '../lawyer_screens/bottom_navigation_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';
import '../../controllers/signin_with_email_controller.dart';
import 'forget_password_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              height: MediaQuery.of(context).size.height*0.2,
              width: double.infinity,
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40,),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(AppLocalizations.of(context)!.login,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(AppLocalizations.of(context)!.email,style: const TextStyle(fontSize: 17,color: Colors.grey),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.please_enter_email,
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.password,
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.please_enter_password,
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 50,),
                  CustomClickRoundedButton(text: "Log In",
                    onPress: ()async{
                    LoginController loginController = LoginController();
                    await loginController.loginAndNavigate(emailController.text ,passwordController.text, context);
                  },),
                  SizedBox(height: 20,),
                  const SizedBox(height: 50,),
                  CustomClickRoundedButton(text: AppLocalizations.of(context)!.login,
                    onPress: ()async{
                      LoginController loginController = LoginController();
                      await loginController.loginAndNavigate(emailController.text ,passwordController.text, context);
                    },),
                  const SizedBox(height: 20,),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context)!.forget_password,style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey
                      ),),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.15,),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(AppLocalizations.of(context)!.sign_up,style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue
                      ),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
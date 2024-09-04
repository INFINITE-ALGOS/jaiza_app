import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:law_education_app/controllers/signup_with_email_controller.dart';
import 'package:law_education_app/screens/auth/userlawyer_profile_collection_screen.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';
import 'package:provider/provider.dart';

import '../../controllers/user_provider.dart';
import '../../conts.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final SignupWithEmailController signupWithEmailController = SignupWithEmailController();

  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool clientSelected = true;
  bool lawyerSelected = false;
  String selectedRole ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
              color: primaryColor,
              width: double.infinity,
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                       'Sign Up',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      title: 'Name',
                      fieldTitle: 'Please enter name',
                      controller: nameController,
                    ),
                    CustomTextField(
                      title: 'Email',
                      fieldTitle: 'PLease enter email',
                      controller: emailController,
                    ),
                    CustomTextField(
                      title: 'Password',
                      fieldTitle: 'Please Enter Password',
                      controller: passwordController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: ()
                          {
                            setState(() {
                              clientSelected=true;
                              lawyerSelected=false;
                              selectedRole='client';
                            });
                          },
                          child: Container(
                            width: 130,
                            height: 50,
                            decoration: BoxDecoration(
                                color: clientSelected?primaryColor:Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color:primaryColor,width: 2)
                            ),
                            child: Center(
                              child: Text("client",style: TextStyle(
                                color: clientSelected?Colors.white:primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300
                              ),),
                            ),
                          ),
                        ),
                        SizedBox(width: 7,),
                        InkWell(
                          onTap: ()
                          {
                            setState(() {
                              clientSelected=false;
                              lawyerSelected=true;
                              selectedRole = 'lawyer';
                            });
                          },
                          child: Container(
                            width: 130,
                            height: 50,
                            decoration: BoxDecoration(
                                color:lawyerSelected?primaryColor:Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: primaryColor,width: 1)
                            ),
                            child: Center(
                              child: Text("Lawyer",style: TextStyle(
                                color: lawyerSelected?Colors.white:primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300
                              ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CustomClickRoundedButton(
                        text: "Sign Up",
                        onPress: () {
                        if(clientSelected)
                        {
                          widget.signupWithEmailController
                              .signUpWithEmailMethod(
                            context: context,
                            userType: selectedRole,
                            userName: nameController.text.trim(),
                            userEmail: emailController.text.trim(),
                            userPassword: passwordController.text.trim(),
                            selectedRole: selectedRole,
                          );
                        }
                        else if(lawyerSelected)
                        {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserlawyerProfileCollectionScreen (), // Replace with your next screen
                            ),
                          );
                        }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding:EdgeInsets.only(left:30),
                          child: Text("Already have an account?",style: TextStyle(
                            fontSize: 15
                          ),),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              'LogIn',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: primaryColor
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  class CustomTextField extends StatelessWidget {
  final String title;
  final String fieldTitle;
  final TextEditingController controller;

  CustomTextField({
    super.key,
    required this.title,
    required this.fieldTitle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: blackColor),
          ),
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: controller,
          //  obscureText: title == AppLocalizations.of(context)!.password ? _obscureText : false,
            decoration: InputDecoration(
              hintText: fieldTitle,
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

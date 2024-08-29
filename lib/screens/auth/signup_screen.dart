import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:law_education_app/controllers/signup_with_email_controller.dart';
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

  String selectedRole = 'client';
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Simplified layout without keyboard visibility handling
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
              color: Colors.grey,
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.sign_up,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      title: AppLocalizations.of(context)!.name,
                      fieldTitle: AppLocalizations.of(context)!
                          .please_enter_name,
                      controller: nameController,
                    ),
                    CustomTextField(
                      title: AppLocalizations.of(context)!.email,
                      fieldTitle: AppLocalizations.of(context)!
                          .please_enter_email,
                      controller: emailController,
                    ),
                    CustomTextField(
                      title: AppLocalizations.of(context)!.password,
                      fieldTitle: AppLocalizations.of(context)!
                          .please_enter_password,
                      controller: passwordController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: "client",
                                groupValue: selectedRole,
                                activeColor: blueColor,
                                onChanged: (value) {
                                  setState(() {
                                    selectedRole = value!;
                                  });
                                },
                              ),
                              Text(AppLocalizations.of(context)!.client),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: "lawyer",
                                groupValue: selectedRole,
                                activeColor: blueColor,
                                onChanged: (value) {
                                  setState(() {
                                    selectedRole = value!;
                                  });
                                },
                              ),
                              Text(AppLocalizations.of(context)!.lawyer),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CustomClickRoundedButton(
                        text: AppLocalizations.of(context)!.sign_up,
                        onPress: () {
                          widget.signupWithEmailController
                              .signUpWithEmailMethod(
                            context: context,
                            userType: selectedRole,
                            userName: nameController.text.trim(),
                            userEmail: emailController.text.trim(),
                            userPassword: passwordController.text.trim(),
                            selectedRole: selectedRole,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
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
                          AppLocalizations.of(context)!.login,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue,
                          ),
                        ),
                      ),
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

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
  final TextEditingController psswordController = TextEditingController();

  String selectedRole = 'client';

  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
   // final userProvider = Provider.of<UserProvider>(context, listen: false);
  String selectedRole = 'client';
  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              isKeyboardVisible
                  ? Container()
                  : Container(
                      color: Colors.grey,
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                    ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                color: Colors.grey,
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
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
                    SizedBox(
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      // padding: EdgeInsets.only(left: 20),
                      child: Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                          AppLocalizations.of(context)!.sign_up,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      title: "Name",
                      fieldTitle: "Please Enter Your Name",
                      controller: nameController,
                    ),
                    CustomTextField(
                      title: "Email",
                      fieldTitle: "Please Enter Your Email",
                      controller: emailController,
                    ),
                    CustomTextField(
                      title: "Password",
                      fieldTitle: "Please Enter Your Password",
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      title: AppLocalizations.of(context)!.name,
                      fieldTitle: AppLocalizations.of(context)!.please_enter_name,
                      controller: nameController,
                    ),
                    CustomTextField(
                      title: AppLocalizations.of(context)!.email,
                      fieldTitle: AppLocalizations.of(context)!.please_enter_email,
                      controller: emailController,
                    ),
                    CustomTextField(
                      title: AppLocalizations.of(context)!.password,
                      fieldTitle: AppLocalizations.of(context)!.please_enter_password,
                      controller: psswordController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 30,),
                        const SizedBox(width: 30,),
                        Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                    value: "client",
                                    groupValue: selectedRole,
                                    activeColor: blueColor,
                                    onChanged: (value)
                                    {
                                      setState(() {
                                        selectedRole=value!;
                                      });
                                    },
                                ),
                                Container(
                                  child: Text("Client"),
                                )
                              ],
                            )
                         ),
                        SizedBox(width: 30,),
                                  value: "client",
                                  groupValue: selectedRole,
                                  activeColor: blueColor,
                                  onChanged: (value)
                                  {
                                    setState(() {
                                      selectedRole=value!;
                                    });
                                  },
                                ),
                                Text(AppLocalizations.of(context)!.client)
                              ],
                            )
                        ),
                        const SizedBox(width: 30,),
                        Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio(
                                  value: "lawyer",
                                  groupValue: selectedRole,
                                  activeColor: blueColor,
                                  onChanged: (value)
                                  {
                                    setState(() {
                                      selectedRole=value!;
                                    });
                                  },
                                ),
                                Container(
                                  child: Text("Lawyer"),
                                )
                                Text(AppLocalizations.of(context)!.lawyer)
                              ],
                            )
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CustomClickRoundedButton(
                        text: "Sign Up",
                        onPress: () {
                          widget.signupWithEmailController
                              .signUpWithEmailMethod(
                                  context: context,
                                  userType: selectedRole,
                                  userName: nameController.text.trim(),
                                  userEmail: emailController.text.trim(),
                                  userPassword: psswordController.text.trim(),
                                  selectedRole: selectedRole);
                        },
                      ),
                    ),
                    SizedBox(
                        text:AppLocalizations.of(context)!.sign_up,
                        onPress: () {
                          widget.signupWithEmailController
                              .signUpWithEmailMethod(
                              context: context,
                              userType: selectedRole,
                              userName: nameController.text.trim(),
                              userEmail: emailController.text.trim(),
                              userPassword: psswordController.text.trim(),
                              selectedRole: selectedRole);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Log In",
                          style: TextStyle(
                          AppLocalizations.of(context)!.login,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class CustomTextField extends StatelessWidget {
  String title;
  String fieldTitle;
  TextEditingController controller;
  CustomTextField(
      {super.key,
      required this.title,
      required this.fieldTitle,
      required this.controller});

        required this.title,
        required this.fieldTitle,
        required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: blackColor)),
          child: TextFormField(
            controller: controller,
            decoration:
                InputDecoration(hintText: fieldTitle, border: InputBorder.none),
          ),
        ),
        SizedBox(
            InputDecoration(hintText: fieldTitle, border: InputBorder.none),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
}

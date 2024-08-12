import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:law_education_app/controllers/signin_with_email_controller.dart';
import 'package:law_education_app/controllers/signup_with_email_controller.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/utils/manage_keyboard.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';

import '../../conts.dart';
import 'login_screen.dart';
class LogInScreen extends StatefulWidget {
  final SigninWithEmailController signinWithEmailController=SigninWithEmailController();
  LogInScreen({super.key});
  @override
  State<LogInScreen> createState() => _LogInScreenState();
}
class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController nameController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController psswordController=TextEditingController();

  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return
        Scaffold(
          backgroundColor: Colors.grey,
          body: SingleChildScrollView(
            child: Column(
              children: [
                isKeyboardVisible?Container(): Container(
                  color: Colors.grey,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.2,
                  width: double.infinity,
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40,),
                      Container(
                        alignment: Alignment.topLeft,
                        // padding: EdgeInsets.only(left: 20),
                        child: Center(
                          child: Text("Log In", style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),),
                        ),
                      ),
                      SizedBox(height: 20,),
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 50,),
                  CustomClickRoundedButton(text: "Log In",
                    onPress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>bottomNavigationbarClient()));

                    //  CustomTextField(title: "Name",fieldTitle: "Please Enter Your Name",controller: nameController,),
                      CustomTextField(title:"Email" ,fieldTitle: "Please Enter Your Email",controller: emailController,),
                      CustomTextField(title: "Password",fieldTitle: "Please Enter Your Password",controller: psswordController,),

                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: CustomClickRoundedButton(text: "LogIn", onPress: () {
                          KeyboardUtil().hideKeyboard(context);
                          widget.signinWithEmailController.signInWithEmailController(userEmail: emailController.text.trim(), userPassword: psswordController.text.trim(), context: context);
                        },),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("Sign Up", style: TextStyle(
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
    } );
  }
}
class CustomTextField extends StatelessWidget {
  String title;
  String fieldTitle;
  TextEditingController controller;
  CustomTextField({super.key,required this.title,required this.fieldTitle,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Container(
        padding: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
            color: Colors.grey),),
      ),
        Container(

          margin: EdgeInsets.only(left: 20,right: 20,top: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),border: Border.all(color: blackColor)),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
                hintText: fieldTitle,
                border:InputBorder.none
            ),
          ),
        ),
        SizedBox(height: 20,),],
    );
  }
}












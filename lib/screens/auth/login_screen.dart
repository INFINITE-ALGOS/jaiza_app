import 'package:flutter/material.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/screens/client_screens/bottom_nav.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';

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
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Log In",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text("E-mail",style: TextStyle(fontSize: 17,color: Colors.grey),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Enter E-mail here',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: TextField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Enter Password here',
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
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 50,),
                  CustomClickRoundedButton(text: "Log In",
                    onPress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>bottomNavigationbarClient()));

                    },),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPasswordScreen(),),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("Forget Password?",style: TextStyle(
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
                      child: Text("Sign Up",style: TextStyle(
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
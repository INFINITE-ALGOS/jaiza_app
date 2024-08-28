import 'package:flutter/material.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';

import 'ottp_verify_screen.dart';
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}
class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
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
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); // Navigate back
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white, // Button color
                          shape: BoxShape.circle, // Rounded shape
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.grey, // Icon color
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Forgot Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
                    child: const Text("Forget Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text("E-mail",style: TextStyle(fontSize: 17,color: Colors.grey),),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
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
                  const SizedBox(height: 30,),
                  CustomClickRoundedButton(text: "Submit",
                    onPress: ()
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OtpVerify(),),
                      );
                    },)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
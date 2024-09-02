import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';

class UserlawyerProfileCollectionScreen extends StatefulWidget {
  const UserlawyerProfileCollectionScreen({super.key});

  @override
  State<UserlawyerProfileCollectionScreen> createState() => _UserlawyerProfileCollectionScreenState();
}

class _UserlawyerProfileCollectionScreenState extends State<UserlawyerProfileCollectionScreen> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController experinceController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController portfolioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Replace with primaryColor if you have a defined color
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              color: primaryColor, // Replace with primaryColor
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
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Please Complete your profile", // Replace with any string you want
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: bioController,
                      decoration: InputDecoration(
                        labelText: "Bio", // Replace with any string you want
                        hintText: "Please enter your bio", // Replace with any string you want
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: experinceController,
                      decoration: InputDecoration(
                        labelText: "Experince", // Replace with any string you want
                        hintText: "Please enter your experinece", // Replace with any string you want
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: designationController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "designation", // Replace with any string you want
                        hintText: "Please enter your designation", // Replace with any string you want
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your sign-up logic here
                        },
                        child: Text("Sign Up"), // Replace with any string you want
                        style: ElevatedButton.styleFrom(

                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/provider/get_categories_provider.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:provider/provider.dart';

class UserlawyerProfileCollectionScreen extends StatefulWidget {
  final Map<String,dynamic> basicInfo;
  File imageFile;
   UserlawyerProfileCollectionScreen({super.key , required this.basicInfo,required this.imageFile});

  @override
  State<UserlawyerProfileCollectionScreen> createState() => _UserlawyerProfileCollectionScreenState();
}

class _UserlawyerProfileCollectionScreenState extends State<UserlawyerProfileCollectionScreen> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController experinceController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController portfolioController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final List<String> expertiseTypes = ['Criminal', 'Real Estate', 'Corporate', 'Family','Personal Injury','Immigeration'];
  final List<String> experience = ['1 year', '2 years', '3 years', '4 years','5 years','5+ years','10+ years'];
  String? selectedExpertise;
  String? selectedExperience;
  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<CategoriesProvider>(context);
    final List<String> expertiseType = categoryList.categoriesList as List<String>;
    return Scaffold(
      backgroundColor: primaryColor, // Replace with primaryColor if you have a defined color
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text("Please complete your profile",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      CustomTextField(
                        title: "Bio",
                        fieldTitle: "Please Enter your Bio",
                        controller: bioController,
                        maxLines: 3,
                      ),
                      CustomTextField(
                        title: "Designation",
                        fieldTitle: "Please Enter your Designation",
                        controller: designationController,
                        maxLines: 1,
                      ),
                      SizedBox(height: 1,),
                      Container(
                          padding: EdgeInsets.only(left: 22,right: 20,bottom: 10),
                          child: Text('Experience',style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 15
                          ),)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedExperience,
                              hint: Text('Select Experience'),
                              items: experience.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type,style: TextStyle(
                                      fontWeight: FontWeight.w400
                                  ),),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedExperience = newValue;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.only(left: 22,right: 20,bottom: 10),
                          child: Text('Expertise Type',style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 15
                          ),)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedExpertise,
                              hint: Text('Select Expertise'),
                              items: expertiseType.map((String type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(
                                    type,
                                    style: TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedExpertise = newValue;
                                });
                              },
                              isExpanded: true,
                            ),
                          )

                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                          padding: EdgeInsets.only(left: 22,right: 20,bottom: 10),
                          child: Text('Portfolio',style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                               fontSize: 17
                          ),)),
                      CustomTextField(
                        title: "Title",
                        fieldTitle: "Please Enter your Title",
                        controller: titleController,
                        maxLines: 1,
                      ),
                      CustomTextField(
                        title: "Description",
                        fieldTitle: "Please Enter your Description",
                        controller: descriptionController,
                        maxLines: 3,
                      ),
                      CustomTextField(
                        title: "URL",
                        fieldTitle: "Please Enter your URL of your portfolio",
                        controller:urlController,
                        maxLines: 1,
                      ),
                      CustomTextField(
                        title: "Date",
                        fieldTitle: "Please Enter date",
                        controller: dateController,
                        maxLines: 1,
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
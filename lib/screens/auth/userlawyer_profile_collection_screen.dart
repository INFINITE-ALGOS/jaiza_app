import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/controllers/signup_with_email_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/models/lawyer_model.dart';
import 'package:law_education_app/provider/get_categories_provider.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';
import 'package:law_education_app/widgets/custom_alert_dialog.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';
import 'package:law_education_app/widgets/custom_scaffold_messanger.dart';
import 'package:provider/provider.dart';

import '../../utils/progress_dialog_widget.dart';

class UserlawyerProfileCollectionScreen extends StatefulWidget {
  final Map<String, dynamic> basicInfo;
  File image;
  UserlawyerProfileCollectionScreen(
      {super.key, required this.basicInfo,required this.image});

  @override
  State<UserlawyerProfileCollectionScreen> createState() =>
      _UserlawyerProfileCollectionScreenState();
}

class _UserlawyerProfileCollectionScreenState
    extends State<UserlawyerProfileCollectionScreen> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController experinceController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController portfolioController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  List selectedCategoriesList = [];
  String photoUrl = '';
  GlobalKey<FormState> formKey = GlobalKey();

  //final List<String> expertiseTypes = ['Criminal', 'Real Estate', 'Corporate', 'Family','Personal Injury','Immigeration'];
  final List<String> experience = [
    '1 year',
    '2 years',
    '3 years',
    '4 years',
    '5 years',
    '5+ years',
    '10+ years'
  ];
  String? selectedExpertise;
  String? selectedExperience;
  Future<void> uploadImageToFirebase(BuildContext context,File image) async {
    //ProgressDialogWidget.show(context,  'Uploading...');
    try
    {
      firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(image);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      photoUrl = await taskSnapshot.ref.getDownloadURL();
     // ProgressDialogWidget.hide(context);
    }
    catch (error)
    {
      ProgressDialogWidget.hide(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<CategoriesProvider>(context);
    final List<dynamic> expertiseType = categoryList.categoriesList;
    return Scaffold(
      backgroundColor:
          primaryColor, // Replace with primaryColor if you have a defined color
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                color: primaryColor,
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Please complete your profile",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                            title: "Bio",
                            fieldTitle: "Please Enter your Bio",
                            controller: bioController,
                            maxLines: 3,
                          validator: (value){
                            if (value == null || value.isEmpty) {
                              return 'Bio cannot be empty';
                            }
                            return null;
                          },              ),          CustomTextField(
                            title: "Designation",
                            fieldTitle: "Please Enter your Designation",
                            controller: designationController,
                            maxLines: 1,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Designation cannot be empty';
                      }
                      return null;
                    },     ),                   SizedBox(
                          height: 1,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                left: 22, right: 20, bottom: 10),
                            child: Text(
                              'Experience',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 15),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
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
                              child: DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Experience cannot be empty';
                                  }
                                  return null;
                                },
                                value: selectedExperience,
                                hint: Text('Select Experience'),
                                items: experience.map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
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
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                left: 22, right: 20, bottom: 10),
                            child: Text(
                              'Expertise Type',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 15),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
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
                              child: DropdownButtonFormField<dynamic>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Expertise cannnot be empty';
                                  }
                                  return null;
                                },
                                value: selectedExpertise,
                                hint: Text('Select Expertise'),
                                items: expertiseType.map((dynamic type) {
                                  return DropdownMenuItem<dynamic>(
                                    value: type,
                                    child: Text(
                                      type.toString(), // Convert dynamic to string for display
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (dynamic newValue) {
                                  if (selectedCategoriesList.length < 5) {
                                    setState(() {
                                      selectedExpertise = newValue;
                                      if (selectedCategoriesList
                                          .contains(selectedExpertise)) {
                                      } else {
                                        selectedCategoriesList
                                            .add(selectedExpertise);
                                      }
                                    });
                                  } else {
                                    CustomScaffoldSnackbar.showSnackbar(context,
                                        "You can't add more than 5 expertise",
                                        backgroundColor: redColor);
                                  }
                                },
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                        selectedCategoriesList.isNotEmpty
                            ? Wrap(
                                spacing: 5.0, // Horizontal space between items
                                runSpacing: 5.0, // Vertical space between lines
                                children: List.generate(
                                    selectedCategoriesList.length, (index) {
                                  return Container(
                                    margin: EdgeInsets.all(
                                        3), // Margins around each item
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            10), // Padding inside the container for text and icon
                                    decoration: BoxDecoration(
                                      color: lightGreyColor, // Background color
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize
                                          .min, // Makes the row take only as much space as its children
                                      children: [
                                        // Text displaying the name of the selected category
                                        Text(
                                          selectedCategoriesList[index],
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        // Cross button to remove the item from the list
                                        IconButton(
                                          padding: EdgeInsets
                                              .zero, // Remove extra padding around the icon
                                          constraints:
                                              BoxConstraints(), // Remove constraints to make the button as small as needed
                                          icon: Icon(Icons.clear,
                                              color: Colors.red,
                                              size: 15), // Smaller clear icon
                                          onPressed: () {
                                            setState(() {
                                              // Remove the item from the list
                                              selectedCategoriesList
                                                  .removeAt(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            thickness: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Portfolio(index: 1),
                        Portfolio(index: 2),
                        Portfolio(index: 3),
                        SizedBox(
                          height: 35,
                        ),
                        CustomClickRoundedButton(
                            text: "Signup",
                            onPress: () async {
                              if (formKey.currentState!.validate()) {
                                final emailSignupController =
                                    SignupWithEmailController();
                                await uploadImageToFirebase(context, widget.image)
                                    .whenComplete(() {
                                  emailSignupController
                                      .lawyerSignUpWithEmailMethod(
                                    context: context,
                                    userName: widget.basicInfo['name'],
                                    userEmail: widget.basicInfo['email'],
                                    userPassword: widget.basicInfo['password'],
                                    selectedRole: 'lawyer',
                                    userType: 'lawyer',
                                    userAddress: widget.basicInfo['address'],
                                    userPhoneNo: widget.basicInfo['phone'],
                                    bio: bioController.text.trim(),
                                    designation:
                                        designationController.text.trim(),
                                    selectedExperience: selectedExperience!,
                                    selectedExpertise: selectedCategoriesList,
                                    url: photoUrl,
                                    portfolio: [],
                                  );
                                });
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Portfolio extends StatelessWidget {
  final index;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Portfolio({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                padding: EdgeInsets.only(left: 22, bottom: 10),
                child: Text(
                  'Portfolio ${index}',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 17),
                )),
            SizedBox(
              width: 10,
            ),
            Text(
              '*optional',
              style: TextStyle(color: redColor),
            ),
          ],
        ),
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
          controller: urlController,
          maxLines: 1,
        ),
        CustomTextField(
          title: "Date",
          fieldTitle: "Please Enter date",
          controller: dateController,
          maxLines: 1,
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}

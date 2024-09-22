import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:law_education_app/controllers/signup_with_email_controller.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/models/lawyer_model.dart';
import 'package:law_education_app/provider/general_provider.dart';
import 'package:law_education_app/screens/auth/signup_screen.dart';
import 'package:law_education_app/utils/custom_snackbar.dart';
import 'package:law_education_app/widgets/custom_alert_dialog.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';
import 'package:law_education_app/widgets/custom_scaffold_messanger.dart';
import 'package:provider/provider.dart';

import '../../utils/progress_dialog_widget.dart';
import 'login_screen.dart';

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
  // final index;
  List<Map<String, dynamic>> portfolios = [];
  int portfolioLength=1;

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
  Future<void> uploadImageToFirebase(BuildContext context, File image) async {
    try {
      firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('uploads/${FirebaseAuth.instance.currentUser?.uid}'); // Null-aware operator
      firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(image);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      photoUrl = await taskSnapshot.ref.getDownloadURL();
      //print("Upload complete. Photo URL: $photoUrl"); // Debug print
    } catch (error) {
      CustomScaffoldSnackbar.showSnackbar(context, error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<GeneralProvider>(context);
    final List<dynamic> expertiseType = categoryList.categoriesNameList;
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
                                dropdownColor: whiteColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Experience cannot be empty';
                                  }
                                  return null;
                                },
                                value: selectedExperience,
                                decoration: InputDecoration(
                                  border: InputBorder.none, // Remove the border/underline
                                ),
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
                                dropdownColor: whiteColor,

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Expertise cannot be empty';
                                  }
                                  return null;
                                },
                                value: selectedExpertise,
                                hint: Text('Select Expertise'),
                                decoration: InputDecoration(
                                  border: InputBorder.none, // Remove the border/underline
                                ),
                                items: expertiseType.map((dynamic type) {
                                  return DropdownMenuItem<dynamic>(
                                    value: type,
                                    child: Text(
                                      type.toString(),
                                      style: TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (dynamic newValue) {
                                  if (selectedCategoriesList.length < 5) {
                                    setState(() {
                                      selectedExpertise = newValue;
                                      if (!selectedCategoriesList.contains(selectedExpertise)) {
                                        selectedCategoriesList.add(selectedExpertise);
                                      }
                                    });
                                  } else {
                                    CustomScaffoldSnackbar.showSnackbar(
                                      context,
                                      "You can't add more than 5 expertise",
                                      backgroundColor: redColor,
                                    );
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


                        PortfolioScreen(onPortfoliosUpdated: (updatedPortfolios) {
                          setState(() {
                            portfolios = updatedPortfolios; // Update the portfolios in parent widget
                          });
                        }),

                        SizedBox(
                          height: 35,
                        ),
                        CustomClickRoundedButton(
                            text: "Signup",
                            onPress: () async {
                              if (formKey.currentState!.validate()) {

                                final emailSignupController =
                                SignupWithEmailController();
                                EasyLoading.show(status: "Please wait");
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
                                    portfolio: portfolios,
                                  );
                                });
                                EasyLoading.dismiss();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                      (Route<dynamic> route) => false,
                                );
                              //  print(portfolios);
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

class PortfolioScreen extends StatefulWidget {
  final Function(List<Map<String, String>>) onPortfoliosUpdated;

  PortfolioScreen({required this.onPortfoliosUpdated});

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int portfolioLength = 1;
  List<Map<String, String>> portfolios = [
    {'title': '', 'description': '', 'url': '', 'date': ''}, // For portfolio 1
  ];

  // Controllers for Portfolio 1
  TextEditingController titleController1 = TextEditingController();
  TextEditingController descriptionController1 = TextEditingController();
  TextEditingController urlController1 = TextEditingController();
  TextEditingController dateController1 = TextEditingController();

  // Controllers for Portfolio 2
  TextEditingController titleController2 = TextEditingController();
  TextEditingController descriptionController2 = TextEditingController();
  TextEditingController urlController2 = TextEditingController();
  TextEditingController dateController2 = TextEditingController();

  // Controllers for Portfolio 3
  TextEditingController titleController3 = TextEditingController();
  TextEditingController descriptionController3 = TextEditingController();
  TextEditingController urlController3 = TextEditingController();
  TextEditingController dateController3 = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Portfolio 1 listeners
    titleController1.addListener(() {
      portfolios[0]['title'] = titleController1.text.trim();
      widget.onPortfoliosUpdated(portfolios);
    });
    descriptionController1.addListener(() {
      portfolios[0]['description'] = descriptionController1.text.trim();
      widget.onPortfoliosUpdated(portfolios);
    });
    urlController1.addListener(() {
      portfolios[0]['url'] = urlController1.text.trim();
      widget.onPortfoliosUpdated(portfolios);
    });
    dateController1.addListener(() {
      portfolios[0]['date'] = dateController1.text.trim();
      widget.onPortfoliosUpdated(portfolios);
    });

    // Portfolio 2 listeners
    titleController2.addListener(() {
      if (portfolioLength > 1) {
        portfolios[1]['title'] = titleController2.text.trim();
        widget.onPortfoliosUpdated(portfolios);
      }
    });
    descriptionController2.addListener(() {
      if (portfolioLength > 1) {
        portfolios[1]['description'] = descriptionController2.text.trim();
        widget.onPortfoliosUpdated(portfolios);
      }
    });
    urlController2.addListener(() {
      if (portfolioLength > 1) {
        portfolios[1]['url'] = urlController2.text.trim();
        widget.onPortfoliosUpdated(portfolios);
      }
    });
    dateController2.addListener(() {
      if (portfolioLength > 1) {
        portfolios[1]['date'] = dateController2.text.trim();
        widget.onPortfoliosUpdated(portfolios);
      }
    });

    // Portfolio 3 listeners (moved outside)
    titleController3.addListener(() {
      if (portfolioLength > 2) {
        portfolios[2]['title'] = titleController3.text.trim();
        widget.onPortfoliosUpdated(portfolios);
      }
    });
    descriptionController3.addListener(() {
      if (portfolioLength > 2) {
        portfolios[2]['description'] = descriptionController3.text.trim();
        widget.onPortfoliosUpdated(portfolios);
      }
    });
    urlController3.addListener(() {
      if (portfolioLength > 2) {
        portfolios[2]['url'] = urlController3.text.trim();
        widget.onPortfoliosUpdated(portfolios);
      }
    });
    dateController3.addListener(() {
      if (portfolioLength > 2) {
        portfolios[2]['date'] = dateController3.text.trim();
        widget.onPortfoliosUpdated(portfolios);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPortfolioSection(1, titleController1, descriptionController1, urlController1, dateController1),
        portfolioLength > 1
            ? buildPortfolioSection(2, titleController2, descriptionController2, urlController2, dateController2)
            : SizedBox(),
        portfolioLength > 2
            ? buildPortfolioSection(3, titleController3, descriptionController3, urlController3, dateController3)
            : SizedBox(),
        portfolioLength<3? IconButton(
          onPressed: () {
            if (portfolioLength < 3) {
              setState(() {
                portfolioLength++;

                portfolios.add({
                  'title': '',
                  'description': '',
                  'url': '',
                  'date': ''
                }); // Add a new empty portfolio


              });
            }
          },
          icon: Icon(Icons.add),
        ) : SizedBox(),
      ],
    );
  }

  Widget buildPortfolioSection(int portfolioNumber, TextEditingController titleController, TextEditingController descriptionController, TextEditingController urlController, TextEditingController dateController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Portfolio $portfolioNumber', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17)),
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
        SizedBox(height: 15),
      ],
    );
  }
}
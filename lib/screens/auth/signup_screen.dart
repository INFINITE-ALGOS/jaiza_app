import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_education_app/controllers/signup_with_email_controller.dart';
import 'package:law_education_app/screens/auth/userlawyer_profile_collection_screen.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';
import '../../conts.dart';
import '../../utils/progress_dialog_widget.dart';
import 'login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


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

  bool islawyerSelected = false;

  File? image;
  final picker = ImagePicker();
  Future<void> choseGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        ProgressDialogWidget.show(context,  'Uploading...');
        image = File(pickedImage.path);
       });
      Navigator.of(context, rootNavigator: true).pop();
    }
    else
    {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
  Future<void> choseCamera() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        ProgressDialogWidget.show(context,  'Uploading...');
        image = File(pickedImage.path);
      });
      Navigator.of(context, rootNavigator: true).pop();
    }
    else
    {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

   void pickImage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.cloud_upload),
                    title: const Text('Upload file'),
                    onTap: () {
                      if (kIsWeb)
                      {
                        Navigator.of(context).pop();
                      }
                      else {
                        choseGallery();
                      }
                    }),
                if(!kIsWeb)
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a photo'),
                    onTap: () =>
                    {
                    Navigator.of(context).pop(),
                    choseCamera(),
                    },
                  ),
              ],
            ),
          );
        });
  }
   String photoUrl = "";

   Future<void> uploadImageToFirebase(BuildContext context,File image) async {
    ProgressDialogWidget.show(context,  'Uploading...');
    try
    {
      firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(image);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      photoUrl = await taskSnapshot.ref.getDownloadURL();
      print("value $photoUrl");
      ProgressDialogWidget.hide(context);
    }
    catch (error)
    {
      ProgressDialogWidget.hide(context);
    }
  }

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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.sign_up,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,

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
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: GestureDetector(
                          onTap: ()
                          {
                            pickImage(context);
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 45,
                                backgroundImage: image != null
                                    ? FileImage(image!)
                                    : NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                              ),
                              InkWell(
                                onTap: ()
                                {},
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: blackColor,
                                  child: const Icon(
                                    Icons.add_sharp,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        title: AppLocalizations.of(context)!.name,
                        fieldTitle: AppLocalizations.of(context)!
                            .please_enter_name,
                        controller: nameController,
                        maxLines: 1,
                      ),
                      CustomTextField(
                        title: AppLocalizations.of(context)!.email,
                        fieldTitle: AppLocalizations.of(context)!
                            .please_enter_email,
                        controller: emailController,
                        maxLines: 1,
                      ),
                      CustomTextField(
                        title: AppLocalizations.of(context)!.password,
                        fieldTitle: AppLocalizations.of(context)!
                            .please_enter_password,
                        controller: passwordController,
                        maxLines: 1,
                      ),
                      CustomTextField(
                        title: "Phone No",
                        fieldTitle: "Please Enter your phone no",
                        controller: phoneController,
                        maxLines: 1,
                      ),
                      CustomTextField(
                        title: "Address",
                        fieldTitle: "Please Enter your Address",
                        controller: addressController,
                        maxLines: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: ()
                            {
                              setState(() {
                                islawyerSelected=false;
                              });
                            },
                            child: Container(
                              width: 130,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: !islawyerSelected?primaryColor:Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color:primaryColor,width: 2)
                              ),
                              child: Center(
                                child: Text("client",style: TextStyle(
                                  color: !islawyerSelected ?Colors.white:primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300
                                ),),
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
                          SizedBox(width: 7,),
                          InkWell(
                            onTap: ()
                            {
                              setState(() {
                                islawyerSelected=true;
                              });
                            },
                            child: Container(
                              width: 130,
                              height: 50,
                              decoration: BoxDecoration(
                                  color:islawyerSelected?primaryColor:Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: primaryColor,width: 1)
                              ),
                              child: Center(
                                child: Text("Lawyer",style: TextStyle(
                                  color: islawyerSelected?Colors.white:primaryColor,
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
                          text: islawyerSelected ? "Continue =>" : AppLocalizations.of(context)!.sign_up,
                          onPress: () async {
                            if (_validateFields()) {
                              if (islawyerSelected) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserlawyerProfileCollectionScreen(
                                      basicInfo: {
                                        'name': nameController.text.trim(),
                                        'email': emailController.text.trim(),
                                        'phone': phoneController.text.trim(),
                                        'address': addressController.text.trim(),
                                      },
                                      imageFile: image!,
                                    ), // Navigate to lawyer data screen
                                  ),
                                );
                              } else {
                                await uploadImageToFirebase(context, image!).whenComplete(() {
                                  widget.signupWithEmailController.signUpWithEmailMethod(
                                    context: context,
                                    userType: "client",
                                    userName: nameController.text.trim(),
                                    userEmail: emailController.text.trim(),
                                    userPassword: passwordController.text.trim(),
                                    userAddress: addressController.text.trim(),
                                    userPhoneNo: phoneController.text.trim(),
                                    selectedRole: "client",
                                    url: photoUrl,
                                  );
                                });
                              }
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
                                AppLocalizations.of(context)!.login,
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
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields()
  {
    if(nameController.text.isEmpty)
    {
      _showDialog("Name is required");
      return false;
    }
    if (emailController.text.isEmpty)
    {
      _showDialog("Email is required");
      return false;
    }
    if(passwordController.text.isEmpty)
    {
      _showDialog("Password is required");
      return false;
    }
    if(phoneController.text.isEmpty)
    {
      _showDialog("Phone Number is required");
      return false;
    }
    if(addressController.text.isEmpty)
    {
      _showDialog("Address is required");
      return false;
    }
    if(image==null)
    {
      _showDialog("Profile Image is required");
      return false;
    }
    return true;
  }

  void _showDialog(String message)
  {
    showDialog(
        context: context,
        builder: (BuildContext context)
        {return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
           TextButton(onPressed: Navigator.of(context).pop, child: Text("OK"))
          ],
        );
        });
  }

}

  class CustomTextField extends StatelessWidget {
  final String title;
  final String fieldTitle;
  final TextEditingController controller;
  final int maxLines;

  CustomTextField({
    super.key,
    required this.title,
    required this.fieldTitle,
    required this.controller,
    required this.maxLines,
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
            maxLines: maxLines,
            textAlignVertical: TextAlignVertical.center,
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



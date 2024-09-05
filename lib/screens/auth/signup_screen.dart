import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_education_app/controllers/signup_with_email_controller.dart';
import 'package:law_education_app/screens/auth/userlawyer_profile_collection_screen.dart';
import 'package:law_education_app/utils/manage_keyboard.dart';
import 'package:law_education_app/utils/validateor.dart';
import 'package:law_education_app/widgets/custom_rounded_button.dart';
import 'package:law_education_app/widgets/custom_scaffold_messanger.dart';
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
  final foemKey=GlobalKey<FormState>();
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
    //ProgressDialogWidget.show(context,  'Uploading...');
    try
    {
      firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(image);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      photoUrl = await taskSnapshot.ref.getDownloadURL();
      ProgressDialogWidget.hide(context);
    }
    catch (error)
    {
      ProgressDialogWidget.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context,isKeyboardVisible){
      return Scaffold(
        backgroundColor: primaryColor,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus(); // Close keyboard

          },
          child: SingleChildScrollView(
            child: Form(
              key: foemKey,
              child: Column(
                children: [
                isKeyboardVisible?Container():  Container(
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
                                'SignUp',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
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
                              title:'Name',
                              fieldTitle:'Please enter name',
                              controller: nameController,
                              maxLines: 1,
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return 'Name cannot be empty';
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              title: 'Email',
                              fieldTitle: "Please Enter Email",
                              controller: emailController,
                              validator: (value){
                              return  FieldValidators.validateEmail(value!);
                              },

                              maxLines: 1,
                            ),
                            CustomTextField(
                              title: "Password",
                              fieldTitle: "Please enter password",
                              controller: passwordController,
                              maxLines: 1,
                              validator: (value){
                              return FieldValidators.validatePassword(value!);
                              },

                            ),
                            CustomTextField(
                              title: "Phone no",
                              fieldTitle: "Please Enter your phone no",
                              controller: phoneController,
                              maxLines: 1,
                              validator: (value){
                                return FieldValidators.validatePhoneNumber(value!);
                              },

                            ),
                            CustomTextField(
                              title: "Address",
                              fieldTitle: "Please Enter your Address",
                              controller: addressController,
                              maxLines: 3,
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return 'Address cannot be empty';
                                }
                                return null;
                              },

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
                                text: islawyerSelected ? "Continue =>" : "Sign Up",
                                onPress: () async {
                                  KeyboardUtil().hideKeyboard(context);
                                  if(foemKey.currentState!.validate() && image!=null){
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
                                              'password':passwordController.text.trim()
                                            },
                                            image: image!,
                                          ), // Navigate to lawyer data screen
                                        ),
                                      );
                                    } else {
                                      await uploadImageToFirebase(context, image!).whenComplete(() {
                                        widget.signupWithEmailController.clientSignUpWithEmailMethod(
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
                                  else{
                                    CustomScaffoldSnackbar.showSnackbar(context, "Please upload your picture",backgroundColor: redColor);

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
                                      "LogIn",
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
          ),
        ),
      );
    });
  }

}

  class CustomTextField extends StatelessWidget {
  final String title;
  final String fieldTitle;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;

  CustomTextField({
    super.key,
    required this.title,
    required this.fieldTitle,
    required this.controller,
    required this.maxLines,
    this.validator,
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
            validator:validator,
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



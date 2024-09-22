import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_education_app/provider/myprofile_controller.dart';
import 'package:law_education_app/screens/client_screens/profile_screen(client).dart';
import 'package:law_education_app/utils/manage_keyboard.dart';
import 'package:law_education_app/utils/validateor.dart';
import 'package:law_education_app/widgets/custom_scaffold_messanger.dart';
import 'package:provider/provider.dart';

import '../../conts.dart';

class EditProfileScreenLawyer extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const EditProfileScreenLawyer({super.key, required this.profileData});

  @override
  State<EditProfileScreenLawyer> createState() =>
      _EditProfileScreenLawyerState();
}

class _EditProfileScreenLawyerState extends State<EditProfileScreenLawyer> {
  final key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  //String? _profileImageUrl;

  File? image;
  final picker = ImagePicker();
  Future<void> choseGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
      // Removed the extra pop here
    }
  }

  Future<void> choseCamera() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
      // Removed the extra pop here
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
                      if (kIsWeb) {
                        Navigator.of(context).pop();
                      } else {
                        choseGallery();
                      }
                    }),
                if (!kIsWeb)
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a photo'),
                    onTap: () => {
                      Navigator.of(context).pop(),
                      choseCamera(),
                    },
                  ),
              ],
            ),
          );
        });
  }

  String photoUrl = '';
  Future<void> uploadImageToFirebase(BuildContext context, File image) async {
    //ProgressDialogWidget.show(context,  'Uploading...');
    try {
      firebase_storage.Reference firebaseStorageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('uploads/${FirebaseAuth.instance.currentUser!.uid}');
      firebase_storage.UploadTask uploadTask =
          firebaseStorageRef.putFile(image);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      photoUrl = await taskSnapshot.ref.getDownloadURL();
      // ProgressDialogWidget.hide(context);
    } catch (error) {
      CustomScaffoldSnackbar.showSnackbar(context, error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profileData['name'];
    _phoneController.text = widget.profileData['phone'];
    _addressController.text = widget.profileData['address'];
    photoUrl = widget.profileData[
        'url']; // Assuming 'url' is the field for the profile picture
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<MyProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
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
                              : NetworkImage(photoUrl),
                        ),
                        InkWell(
                          onTap: () {},
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return "Please enter name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _phoneController,
                  validator: (value) {
                    return FieldValidators.validatePhoneNumber(value!);
                  },
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                TextFormField(
                  controller: _addressController,
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return "Please enter address";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () async {
                    KeyboardUtil().hideKeyboard(context);

                    if (key.currentState!.validate()) {
                      // Ensure either a new image is selected or an existing URL is available
                      if (image != null || photoUrl.isNotEmpty) {
                        if (image != null) {
                          EasyLoading.show(status: "Please wait");

                          // Only upload the image if a new one is selected
                          await uploadImageToFirebase(context, image!)
                              .whenComplete(() {
                            profileProvider.updateProfileData({
                              'name': _nameController.text.trim(),
                              'phone': _phoneController.text.trim(),
                              'address': _addressController.text.trim(),
                              'url': photoUrl, // Set the updated image URL
                            });
                          });
                          EasyLoading.dismiss();
                        } else {
                          EasyLoading.show(status: "Please wait");
                          // If no new image is selected, just update other fields with the current photo URL
                          await profileProvider.updateProfileData({
                            'name': _nameController.text.trim(),
                            'phone': _phoneController.text.trim(),
                            'address': _addressController.text.trim(),
                            'url': photoUrl, // Use the existing URL
                          });
                          EasyLoading.dismiss();
                        }

                        // Navigate back to the profile screen
                        Navigator.pushAndRemoveUntil(
                            context,
                            (MaterialPageRoute(
                                builder: (context) => ProfileScreenClient())),
                            (Route<dynamic> route) => route.isFirst);
                      } else {
                        CustomScaffoldSnackbar.showSnackbar(
                            context, "Please select a profile picture.");
                      }
                    }
                  },
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(color: whiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:law_education_app/models/lawyer_model.dart';

import '../models/client_model.dart';
import 'image_handler_controller.dart';

class MyProfileController extends ChangeNotifier{

FirebaseAuth _auth= FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>?> getProfileData() async {
  DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .get();
  return doc.data();
}

Future<void> updateProfileDataLawyer(LawyerModel updatedData) async {
  if (_auth.currentUser != null) {
    await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update(updatedData.toMap());
  }
}

Future<void> updateProfileDataClient(ClientModel updatedData) async {
  if (_auth.currentUser != null) {
    await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update(updatedData.toMap());
  }
}




// final picker = ImagePicker();
// XFile? _image;
//
// XFile? get image => _image;
//
// Future pickImageFromGallery(BuildContext context)async
// {
//   final pickedImage = await picker.pickImage(source: ImageSource.gallery,imageQuality: 100);
//   if(pickedImage!=null)
//   {
//     print('Image picked from gallery: ${pickedImage.path}');
//     _image = XFile(pickedImage.path);
//     await _uploadImage(context); // Upload image after picking
//     notifyListeners();
//
//   }
// }
//
// Future pickImageFromCamera(BuildContext context)async
// {
//   final pickedImage = await picker.pickImage(source: ImageSource.camera,imageQuality: 100);
//   if(pickedImage!=null)
//   {
//     _image=XFile(pickedImage.path);
//
//     Navigator.pop(context);
//
//     notifyListeners();
//   }
// }
// Future<void> _uploadImage(BuildContext context) async {
//   if (_image != null) {
//     try {
//       print('Uploading image: ${_image!.path}');
//       File imageFile = File(_image!.path);
//       String imageUrl = await ImageHandler.uploadImageToFirebase(context, _image);
//       print('Uploaded image URL: $imageUrl');
//       if (_auth.currentUser != null) {
//         await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
//           'url': imageUrl,
//         });
//         notifyListeners();
//       }
//     } catch (e) {
//       print("Error during upload: $e");
//       CoolAlert.show(
//         context: context,
//         type: CoolAlertType.error,
//         text: "Failed to upload image: $e",
//       );
//     }
//   } else {
//     CoolAlert.show(
//       context: context,
//       type: CoolAlertType.error,
//       text: "No image selected!",
//     );
//   }
// }
// void pickImage(context)
// {
//   showDialog(
//       context:context,
//       builder: (BuildContext context)
//       {
//         return AlertDialog(
//           content: Container(
//             height: 120,
//             child: Column(
//               children: [
//                 ListTile(
//                   onTap: ()async
//                   {
//                     await pickImageFromCamera(context);
//                     //Navigator.pop(context);
//                   },
//                   leading: Icon(Icons.camera),
//                   title: Text("Camera"),
//                 ),
//                 ListTile(
//                   onTap: ()
//                   {
//                     pickImageFromGallery(context);
//                     //Navigator.pop(context);
//                   },
//                   leading: Icon(Icons.image),
//                   title: Text("Gallery"),
//                 )
//               ],
//             ),
//           ),
//         );
//       }
//   );
// }

}
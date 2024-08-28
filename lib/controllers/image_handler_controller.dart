import 'dart:io'; // For File handling
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore usage (if needed)
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
// import 'package:flutter/foundation.dart'; // For kIsWeb
// import 'package:flutter/material.dart'; // For Flutter widgets
// import 'package:image_picker/image_picker.dart'; // For picking images
// import 'package:sn_progress_dialog/progress_dialog.dart'; // For showing progress dialogs
// import 'package:cool_alert/cool_alert.dart'; // For showing alert dialogs
//
//
//
// class ImageHandler {
//
//   static Future<String> uploadFileToFirebase(BuildContext context,
//       imageFile) async {
//     //Initializes an empty String called url to store the image URL after it's uploaded.
//     String url = "";
//
//     //Creates a progress dialog that will be shown during the upload process.
//     final ProgressDialog pr = ProgressDialog(context: context);
//
//     //Shows the progress dialog with a message "Uploading Image". max: 100 means the progress bar will go from 0 to 100%
//     pr.show(max: 100, msg: 'Uploading Image', barrierDismissible: false);
//
//     //reference varaible is created , with store data with uniqueness of time and on folder profileImage
//     Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
//         'profileImage/${DateTime.now().millisecondsSinceEpoch}');
//
//     //UploadTask is a class provided by the Firebase Storage package,
//     //putFile() is used to upload the image as a file.
//     UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
//
//     //This is a class provided by Firebase Storage that holds the result or state of an upload task after it has completed. It gives you information about:
//     TaskSnapshot taskSnapshot = await uploadTask;
//     await taskSnapshot.ref.getDownloadURL().then((value) async {
//       url = value;
//       print("func $url");
//       pr.close();
//     }).onError((error, stackTrace) {
//       pr.close();
//       CoolAlert.show(
//         context: context,
//         type: CoolAlertType.error,
//         text: error.toString(),
//       );
//     });
//     return url;
//   }
//
//   static Future<String> uploadImageToFirebase(BuildContext context,
//       imageFile) async {
//     String url = "";
//     final ProgressDialog pr = ProgressDialog(context: context);
//     pr.show(max: 100, msg: 'Uploading Image', barrierDismissible: false);
//     Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
//         'uploads/${DateTime.now().millisecondsSinceEpoch}');
//     UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
//     TaskSnapshot taskSnapshot = await uploadTask;
//     await taskSnapshot.ref.getDownloadURL().then((value) async {
//       url = value;
//       print("func $url");
//       pr.close();
//     }).onError((error, stackTrace) {
//       pr.close();
//       CoolAlert.show(
//         context: context,
//         type: CoolAlertType.error,
//         text: error.toString(),
//       );
//     });
//     return url;
//   }
// }
//
//
//

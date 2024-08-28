import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:law_education_app/utils/progress_dialog_widget.dart';



class ImageUploadService {
  static String _photoUrl = "";

  static String get photoUrl => _photoUrl;

  static Future<void> uploadImageToFirebase(BuildContext context,File image) async {

    // whenever used need to also copy the Progress Dialog widget with it
    // progress dialog widget is a seperare widget which is made with prgress dialog package
    ProgressDialogWidget.show(context,  'Uploading...');

    try {
      firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('uploads/${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(image);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      _photoUrl = await taskSnapshot.ref.getDownloadURL();
      print("value $_photoUrl");


      ProgressDialogWidget.hide(context);

    } catch (error) {

      ProgressDialogWidget.hide(context);
    }
  }

  static Future<void> chooseGallery(BuildContext context) async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        uploadImageToFirebase(context, File(value.path))
            .whenComplete(() => Navigator.pop(context));
      }
    });
  }

  static Future<void> chooseCamera(BuildContext context) async {
    await ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        uploadImageToFirebase(context, File(value.path))
            .whenComplete(() => Navigator.pop(context));
      }
    });
  }

  static void pickImage(BuildContext context) {
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

                      }
                      else {
                        chooseGallery(context);
                      }
                    }),
                if(!kIsWeb)
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a photo'),
                    onTap: () =>
                    {
                      chooseCamera(context)
                    },
                  ),
              ],
            ),
          );
        });
  }
}


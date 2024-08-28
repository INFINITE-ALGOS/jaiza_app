import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class PDFProvider with ChangeNotifier {
  // List to store URLs and names of uploaded PDFs
  final List<Map<String, String>> _pdfs = [];

  // Getter to access pdfs
  List<Map<String, String>> get pdfs => _pdfs;

  // Method to upload a PDF file to Firebase Storage
  Future<void> uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('law_books/${file.uri.pathSegments.last}');

      try {
        // Upload the file to Firebase Storage
        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();

        // Add the URL and file name to the list of PDFs
        _pdfs.add({
          'url': downloadUrl,
          'name': file.uri.pathSegments.last
        });
        notifyListeners(); // Notify listeners to rebuild UI
      } catch (e) {
        print('Failed to upload file: $e');
      }
    } else {
      print('No file selected.');
    }
  }

  // Method to list all PDF files from Firebase Storage
  Future<void> listPDFs() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference listRef = storage.ref().child('law_books');

    ListResult result = await listRef.listAll();
    _pdfs.clear(); // Clear the list to avoid duplicates

    for (Reference ref in result.items) {
      String url = await ref.getDownloadURL();
      String name = ref.name; // Get the file name
      _pdfs.add({'url': url, 'name': name});
    }

    notifyListeners(); // Notify listeners to rebuild UI with new data
  }
}

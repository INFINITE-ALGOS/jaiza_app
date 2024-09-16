
// must understand and practise it

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfViewerScreen extends StatefulWidget {
  final String fileUrl;
  final String title;

  PdfViewerScreen({required this.fileUrl, required this.title});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late Future<String> _pdfPath; // it will store value of downloaded pdfpath once initfunction is run


  @override
  void initState() {
    super.initState();
    //_downloadAndSavePdf(widget.fileUrl): This is a custom function that is called when the screen
    // is initialized. It starts the process of downloading the PDF from the provided URL and saving
    // it temporarily on the device.
    _pdfPath = _downloadAndSavePdf(widget.fileUrl);
  }

  Future<String> _downloadAndSavePdf(String url) async {
    //This creates an instance of the HttpClient class from the dart:io library.
    // The HttpClient is responsible for handling network requests, in this case, downloading the
    // PDF file from the internet.
    final httpClient = HttpClient();

    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/pdf_file.pdf');
    final fileSink = file.openWrite();

    await response.listen((List<int> chunk) {
      fileSink.add(chunk);
    }).asFuture(); // Wait until the entire file has been written

    await fileSink.close(); // Close the file sink

    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<String>(
        future: _pdfPath,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data'));
          } else {
            return PDFView(
              filePath: snapshot.data!,
            );
          }
        },
      ),
    );
  }
}
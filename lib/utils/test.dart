import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/pdf_provider.dart'; // Import pdf_provider

class PdfTestScreen extends StatelessWidget {
  const PdfTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PDFProvider>(context); // Access the provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Law Books PDF Storage'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              pdfProvider.uploadPDF(); // Call upload method
            },
            child: const Text('Upload PDF'),
          ),
          ElevatedButton(
            onPressed: () {
              pdfProvider.listPDFs(); // Call list method
            },
            child: const Text('List PDFs'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pdfProvider.pdfs.length,
              itemBuilder: (context, index) {
                final pdf = pdfProvider.pdfs[index];
                return ListTile(
                  title: Text(pdf['name'] ?? 'Unnamed PDF'),
                  onTap: () {
                    _launchURL(pdf['url']!, context);
                    // Open the PDF in the browser
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('Could not launch $url');
        _showErrorDialog(context, 'Could not launch the URL.');
      }
    } catch (e) {
      print('Error launching URL: $e');
      _showErrorDialog(context, 'Error launching URL.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

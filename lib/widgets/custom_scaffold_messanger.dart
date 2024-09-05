import 'package:flutter/material.dart';

class CustomScaffoldSnackbar {
  // Method to show a SnackBar
  static void showSnackbar(BuildContext context, String message, {Color? backgroundColor}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor ?? Colors.black, // Optional background color
      duration: Duration(seconds: 3), // Duration the message will be visible
    );

    // Show the snackbar using ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

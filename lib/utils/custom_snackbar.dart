import 'package:flutter/material.dart';
class CustomSnackbar{

  static void showError({required BuildContext context, required String title, required String message}) {
    _showSnackbar(
      context,
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void showSuccess({required BuildContext context, required String title, required String message}) {
    _showSnackbar(
      context,
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  static void _showSnackbar(
      BuildContext context,
      String title,
      String message, {
        required Color backgroundColor,
        required Color colorText,
      }) {
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        '$title\n$message',
        style: TextStyle(color: colorText),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
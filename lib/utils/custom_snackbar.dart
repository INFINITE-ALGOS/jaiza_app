import 'package:flutter/material.dart';

class CustomSnackbar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showError({required String title, required String message}) {
    _showSnackbar(
      title,
      message,
      backgroundColor: Colors.black12,
      colorText: Colors.red,
    );
  }

  static void showSuccess({required String title, required String message}) {
    _showSnackbar(
      title,
      message,
      backgroundColor: Colors.black12,
      colorText: Colors.green,
    );
  }

  static void _showSnackbar(
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
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}

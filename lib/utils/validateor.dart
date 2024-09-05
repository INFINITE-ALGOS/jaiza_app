import 'package:flutter/material.dart';

class FieldValidators {
  // Regular expression for validating an email address
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Regular expression for validating a phone number (example: US phone numbers)
  static final RegExp phoneRegex = RegExp(
    r'^\+?1?\d{10,15}$', // Basic validation for US phone numbers
  );

  // Regular expression for validating a password (example: at least 8 characters, including uppercase, lowercase, digits, and special characters)
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  // Validation methods for each field
  static String? validateEmail(String valueValidator) {
    if (valueValidator.isEmpty) {
      return 'Email cannot be empty';
    } else if (!emailRegex.hasMatch(valueValidator)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePhoneNumber(String valueValidator) {
    if (valueValidator.isEmpty) {
      return 'Phone number cannot be empty';
    } else if (!phoneRegex.hasMatch(valueValidator)) {
      return 'Invalid phone number format';
    }
    return null;
  }

  static String? validatePassword(String valueValidator) {
    if (valueValidator.isEmpty) {
      return 'Password cannot be empty';
    } else if (!passwordRegex.hasMatch(valueValidator)) {
      return 'Password must be at least 8 characters long and include uppercase, lowercase, digits, and special characters';
    }
    return null;
  }
}

// lib/services/store_utils.dart
import 'package:flutter/material.dart';

class StoreUtils {
  // Show error message
  static void showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  // Show success message
  static void showSuccess(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  static void showInfo(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.blue),
      );
    }
  }
  // Validate phone number
  static bool validatephone(BuildContext context, String phone) {
    final trimmedPhone = phone.trim();

    if (trimmedPhone.isEmpty) {
      showError(context, 'Please enter your phone number');
      return false;
    } else if (trimmedPhone.length < 10 || trimmedPhone.length > 11) {
      
      showError(context, 'you Have Entered $trimmedPhone Phone number must be between 10-11 digits');
      return false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(trimmedPhone)) {
      showError(context, 'Phone number must contain only digits');
      return false;
    }

    return true;
  }


  // Show loading dialog
  static void showLoading(BuildContext context, String message) {
    if (context.mounted) { 
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
    }
  }

  // Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }

}

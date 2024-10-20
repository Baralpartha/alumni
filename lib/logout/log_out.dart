import 'package:flutter/material.dart';
import '../Login_screen.dart';

class LogoutDialog {
  static Future<void> showLogoutDialog(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog with a 'No'
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog with a 'Yes'
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    // If the user confirmed they want to log out, navigate to the login screen
    if (shouldLogout == true) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your actual LoginScreen widget
            (route) => false, // Removes all previous routes
      );
    }
  }
}

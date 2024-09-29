import 'package:flutter/material.dart';

import 'Home_screen.dart';

// Assume you have imported your User model

class UserProfileScreen extends StatelessWidget {
  final User user; // Accept user object

  UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.memName), // Display user name in app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.memName}'),
            Text('Mobile No: ${user.memMobileNo}'),
            // Add more user details as needed
          ],
        ),
      ),
    );
  }
}

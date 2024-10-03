import 'package:flutter/material.dart';

import 'Home_screen.dart';
import 'EditProfileScreen.dart'; // Import the EditProfileScreen

class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user; // Initialize with the user passed from the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_user.memName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigate to the EditProfileScreen and wait for the result
              final updatedUser = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: _user),
                ),
              );

              // Check if updatedUser is not null and update the state
              if (updatedUser != null) {
                setState(() {
                  _user = updatedUser; // Update the user data
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${_user.memName}', style: const TextStyle(fontSize: 20)),
            Text('Mobile No: ${_user.memMobileNo}', style: const TextStyle(fontSize: 16)),
            Text('Father\'s Name: ${_user.fName ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Mother\'s Name: ${_user.mName ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Present Address: ${_user.preAddr ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Present Phone: ${_user.prePhone ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Present Email: ${_user.preEmail ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Permanent Address: ${_user.perAddr ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Permanent Phone: ${_user.perPhone ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Permanent Email: ${_user.perEmail ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Office Name: ${_user.officeName ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Office Address: ${_user.offAddr ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Office Phone: ${_user.offPhone ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Office Email: ${_user.offEmail ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Date of Birth: ${_user.dob ?? "N/A"}', style: const TextStyle(fontSize: 16)),
            Text('Designation: ${_user.designation ?? "N/A"}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

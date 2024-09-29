import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final bool isEditable;

  const EditProfileScreen({
    Key? key,
    required this.isEditable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 120, // Increase width to make the profile picture bigger
                height: 120, // Increase height to make the profile picture bigger
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 4), // Black border
                ),
                child: CircleAvatar(
                  radius: 60, // Adjust radius to match container size
                  backgroundImage: AssetImage('assets/default_avatar.png'), // Default avatar
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    enabled: isEditable,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone'),
                    enabled: isEditable,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    enabled: isEditable,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Roll'),
                    enabled: isEditable,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Group'),
                    enabled: isEditable,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Blood Group'),
                    enabled: isEditable,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Occupation'),
                    enabled: isEditable,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Make button fill available width
                    child: ElevatedButton(
                      onPressed: isEditable ? () {} : null,
                      child: Text('Save Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

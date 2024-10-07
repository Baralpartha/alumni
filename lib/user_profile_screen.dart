import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'Home_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final User user; // Assuming User is a defined class with necessary fields

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late User _user;
  // Create TextEditingControllers for each field to allow editing
  late TextEditingController _mobileController;
  late TextEditingController _fatherNameController;
  late TextEditingController _motherNameController;
  late TextEditingController _designationController;
  late TextEditingController _officeNameController;

  @override
  void initState() {
    super.initState();
    _user = widget.user; // Initialize with the user passed from the previous screen

    // Initialize controllers with current user data
    _mobileController = TextEditingController(text: _user.memMobileNo);
    _fatherNameController = TextEditingController(text: _user.fName);
    _motherNameController = TextEditingController(text: _user.mName);
    _designationController = TextEditingController(text: _user.designation);
    _officeNameController = TextEditingController(text: _user.officeName);
  }

  // Function to decode Base64 string
  Uint8List? decodeBase64(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null; // Return null if the Base64 string is null or empty
    }
    try {
      return base64Decode(base64String);
    } catch (e) {
      print("Error decoding Base64: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_user.memName ?? "User Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile image at the top center
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _user.memPhoto != null && _user.memPhoto!.isNotEmpty
                      ? MemoryImage(decodeBase64(fixBase64(_user.memPhoto!)) ?? Uint8List(0)) // Ensure we are passing a non-nullable Uint8List
                      : const AssetImage('assets/default_profile.png') as ImageProvider, // Fallback image
                ),
              ),
              const SizedBox(height: 20),

              // User information section with circular border
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center( // Centering the username
                        child: Text(
                          _user.memName ?? "N/A",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Editable fields with TextField
                      _buildTextField('Mobile No', _mobileController),
                      _buildTextField('Father\'s Name', _fatherNameController),
                      _buildTextField('Mother\'s Name', _motherNameController),
                      _buildTextField('Designation', _designationController),
                      _buildTextField('Office Name', _officeNameController),

                      // Add other fields similarly
                      // You can add additional fields as necessary
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a text field with circular border
  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFFC0392B)), // Label color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0), // Circular border
            borderSide: const BorderSide(color: Color(0xFF1A5276)), // Border color
          ),
        ),
      ),
    );
  }

  // Function to fix the Base64 string if necessary
  String fixBase64(String base64String) {
    // Implement any necessary logic to fix or validate the base64 string
    return base64String; // Example placeholder, modify as needed
  }
}

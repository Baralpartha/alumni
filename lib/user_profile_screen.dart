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

class _UserProfileScreenState extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  late User _user;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _user = widget.user; // Initialize with the user passed from the previous screen
    _tabController = TabController(length: 3, vsync: this); // Three tabs for addresses
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
                      Center(
                        child: Text(
                          _user.memName ?? "N/A",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Display fields only if they are not null
                      if (_user.memMobileNo != null && _user.memMobileNo!.isNotEmpty) _buildReadOnlyTextField('Mobile No', _user.memMobileNo!),
                      if (_user.fName != null && _user.fName!.isNotEmpty) _buildReadOnlyTextField('Father\'s Name', _user.fName!),
                      if (_user.mName != null && _user.mName!.isNotEmpty) _buildReadOnlyTextField('Mother\'s Name', _user.mName!),
                      if (_user.designation != null && _user.designation!.isNotEmpty) _buildReadOnlyTextField('Designation', _user.designation!),
                      if (_user.preEmail != null && _user.preEmail!.isNotEmpty) _buildReadOnlyTextField('Present Email', _user.preEmail!),

                      // TabBar for additional fields placed below the Present Email
                      const SizedBox(height: 20),
                      TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Color(0xFFC0392B), // Active tab color
                          borderRadius: BorderRadius.circular(10), // Rounded corners for indicator
                        ),
                        labelColor: Colors.white, // Text color for active tab
                        unselectedLabelColor: Colors.black, // Text color for inactive tabs
                        tabs: [
                          Container(
                            width: 100, // Set the desired width for the tab
                            child: Tab(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Present', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // First line
                                  Text('Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // Second line
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100, // Set the desired width for the tab
                            child: Tab(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Permanent', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // First line
                                  Text('Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // Second line
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100, // Set the desired width for the tab
                            child: Tab(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Office', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // First line
                                  Text('Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), // Second line
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20), // Space between TabBar and TabBarView
                      Container(
                        height: 300, // Fixed height to prevent overflow
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _presentAddressTab(_user.preAddr, _user.prePhone),

                            _permanentAddressTab(_user.perAddr, _user.perPhone),
                            _officeAddressTab(_user.officeName, _user.offPhone), // Assuming officePhone is defined
                          ],
                        ),
                      ),

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

  // Helper method to build a read-only text field with circular border and black text color
  Widget _buildReadOnlyTextField(String labelText, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: TextEditingController(text: text),
        readOnly: true, // Set to true to make it read-only
        style: const TextStyle(color: Colors.black), // Set text color to black
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

  // Method to create a tab for address fields
  Widget _presentAddressTab(String? address, String? phone) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (address != null && address.isNotEmpty) _buildReadOnlyTextField('Address', address),
          if (phone != null && phone.isNotEmpty) _buildReadOnlyTextField('Phone', phone),
        ],
      ),
    );
  }

  // Method to create a tab for address fields
  Widget _permanentAddressTab(String? address, String? phone) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (address != null && address.isNotEmpty) _buildReadOnlyTextField('Address', address),
          if (phone != null && phone.isNotEmpty) _buildReadOnlyTextField('Phone', phone),
        ],
      ),
    );
  }

  // Method to create a tab for address fields
  Widget _officeAddressTab(String? address, String? phone) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (address != null && address.isNotEmpty) _buildReadOnlyTextField('Address', address),
          if (phone != null && phone.isNotEmpty) _buildReadOnlyTextField('Phone', phone),
        ],
      ),
    );
  }

  // Function to fix the Base64 string if necessary
  String fixBase64(String base64String) {
    // Implement any necessary logic to fix or validate the base64 string
    return base64String; // Example placeholder, modify as needed
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the tab controller
    super.dispose();
  }
}

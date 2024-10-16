import 'dart:convert';
import 'package:alumni/profession_list.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'Home_screen.dart';
import 'addrees_api.dart';

class UserProfileScreen extends StatefulWidget {
  final User user; // Assuming User is a defined class with necessary fields


  UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with SingleTickerProviderStateMixin {
  late User _user;
  late TabController _tabController;
  String? divisionDesc;

  @override
  void initState() {
    super.initState();
    _user = widget.user; // Initialize with the user passed from the previous screen

    // Initialize the TabController with the correct length (4 tabs)
    _tabController = TabController(length: 4, vsync: this); // 4 tabs including Family Info

    // Get division description and update it in the state
    setState(() {
      divisionDesc = getDivisionDesc(_user.preDiv ?? ""); // Handle null safely
    });
  }


  // Function to get the profession description based on the code
  String getProfessionDesc(String profCode) {
    // Find the profession in the list using the code
    final profession = professions.firstWhere(
          (element) => element['PROF_CODE'] == profCode,
      orElse: () => {'PROF_DESC': 'Unknown'}, // Default value if code is not found
    );
    return profession['PROF_DESC']!;
  }


  // Function to get the group description based on the code
  // Function to get the category description based on the code
  String getCategoryDesc(String catCode) {
    // Find the category in the map using the code
    final category = catCodes.keys.firstWhere(
          (key) => catCodes[key] == catCode,
      orElse: () => 'Unknown', // Default value if code is not found
    );
    return category;
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

  String getDivisionDesc(String divCode) {
    final division = divisions.firstWhere(
          (element) => element['DIV_CODE'] == divCode,
      orElse: () => {'DIV_DESC': 'Unknown'}, // Default value if not found
    );
    return division['DIV_DESC']!;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alapon-NDC90",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile image at the top center
              Center(
                child: CircleAvatar(
                  radius:70,
                  backgroundImage: _user.memPhoto != null && _user.memPhoto!.isNotEmpty
                      ? MemoryImage(decodeBase64(fixBase64(_user.memPhoto!)) ?? Uint8List(0))
                      : const AssetImage('assets/default_profile.png') as ImageProvider,
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
                      if (_user.memMobileNo != null && _user.memMobileNo!.isNotEmpty)
                        _buildReadOnlyTextField('Mobile Number', _user.memMobileNo!),
                      if (_user.designation != null && _user.designation!.isNotEmpty)
                        _buildReadOnlyTextField('Designation', _user.designation!),
                      if (_user.officeName != null && _user.officeName!.isNotEmpty)
                        _buildReadOnlyTextField('Office', _user.officeName!),
                      if (_user.preEmail != null && _user.preEmail!.isNotEmpty)
                        _buildReadOnlyTextField('Email', _user.preEmail!),
                      if (_user.collRollNo != null && _user.collRollNo!.isNotEmpty)
                        _buildReadOnlyTextField('Roll Number', _user.collRollNo!),
                      if (_user.profCode != null && _user.profCode!.isNotEmpty)
                        _buildReadOnlyTextField('Profession', getProfessionDesc(_user.profCode!)),
                      if (_user.catCode != null && _user.catCode!.isNotEmpty)
                        _buildReadOnlyTextField('Group', getCategoryDesc(_user.catCode!)),


                      const SizedBox(height: 20),

                      // TabBar for additional fields placed below the Present Email
                      TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Color(0xFFC0392B), // Active tab color
                          borderRadius: BorderRadius.circular(10), // Rounded corners for indicator
                        ),
                        labelColor: Colors.white, // Text color for active tab
                        unselectedLabelColor: Colors.black, // Text color for inactive tabs
                        tabs: [
                          _buildTab('Present\nAddress'),
                          _buildTab('Permanent\nAddress'),
                          _buildTab('Office\nAddress'),
                          _buildTab('Family\nInfo'),  // Added new tab for Family Info
                        ],
                      ),

                      const SizedBox(height: 20),

                      // TabBarView for showing the different sections
                      Container(
                        height: 400, // Set a fixed height to prevent overflow
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _presentAddressTab(
                              _user.preAddr,
                              _user.prePhone,
                              divisionDesc, // Pass the division description
                              _user.preThana,
                              _user.preDist,
                              _user.prePostCode,
                              _user.dom,
                            ),
                            _permanentAddressTab(_user.perAddr, _user.perPhone, _user.perDiv, _user.perThana, _user.perDist),
                            _officeAddressTab(_user.offAddr, _user.offPhone, _user.offEmail),
                            _familyInfoTab(_user.fName, _user.mName),  // Added Family Info Tab view
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


// Method to build the Family Info Tab
  Widget _familyInfoTab(String? fatherName, String? motherName) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fatherName != null && fatherName.isNotEmpty)
            _buildReadOnlyTextField('Father\'s Name', fatherName),
          if (motherName != null && motherName.isNotEmpty)
            _buildReadOnlyTextField('Mother\'s Name', motherName),
        ],
      ),
    );
  }


// Method to build a read-only TextField (box) for displaying information
  Widget _buildReadOnlyTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }


// Function to create tabs with auto-fitting text for different screen sizes
  Tab _buildTab(String label) {
    return Tab(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          textAlign: TextAlign.center, // Ensure the text is centered
          style: TextStyle(
            fontSize: 16, // Initial font size, can adjust as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  // Helper method to build a read-only text field with circular border and black text color
  Widget _buildCustomReadOnlyTextField(String labelText, String text) {
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


  // Method to create a tab for Present Address fields
  Widget _presentAddressTab(String? preAddr, String? prePhone, String? preDiv, String? preThana, String? preDist, String? prePostCode,String? dom) {
    print('DOM value: $dom');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (preAddr != null && preAddr!.isNotEmpty) _buildReadOnlyTextField('Present Address', preAddr!),
          if (prePhone != null && prePhone!.isNotEmpty) _buildReadOnlyTextField('Phone', prePhone!),
          if (preDiv != null && preDiv!.isNotEmpty) _buildReadOnlyTextField('Division', preDiv!),
          if (preThana != null && preThana!.isNotEmpty) _buildReadOnlyTextField('Thana', preThana!),
          if (preDist != null && preDist!.isNotEmpty) _buildReadOnlyTextField('District', preDist!),
          if (prePostCode != null && prePostCode!.isNotEmpty) _buildReadOnlyTextField('Postcode', prePostCode!),
          if (dom != null && dom!.isNotEmpty) _buildReadOnlyTextField('Date Of Marriage', dom!),
        ],

      ),
    );
  }

  // Method to create a tab for Permanent Address fields
  Widget _permanentAddressTab(String? address, String? phone, String? div, String? thana, String? dist) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (address != null && address.isNotEmpty) _buildReadOnlyTextField('Address', address),
          if (phone != null && phone.isNotEmpty) _buildReadOnlyTextField('Phone', phone),
          if (div != null && div.isNotEmpty) _buildReadOnlyTextField('Division', div),
          if (thana != null && thana.isNotEmpty) _buildReadOnlyTextField('Thana', thana),
          if (dist != null && dist.isNotEmpty) _buildReadOnlyTextField('District', dist),
        ],
      ),
    );
  }

  // Method to create a tab for Office Address fields
  Widget _officeAddressTab(String? offAddr, String? phone, String? email) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (offAddr != null && offAddr.isNotEmpty) _buildReadOnlyTextField('Office Address', offAddr),
          if (phone != null && phone.isNotEmpty) _buildReadOnlyTextField('Phone', phone),
          if (email != null && email.isNotEmpty) _buildReadOnlyTextField('Email', email),
        ],
      ),
    );
  }

  // Helper method to build a custom tab
  Widget _pbuildTab(String title) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // Helper method to fix the Base64 string before decoding
  String fixBase64(String base64) {
    return base64.replaceAll('data:image/png;base64,', '').replaceAll(' ', '+');
  }
}
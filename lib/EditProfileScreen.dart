import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'Home_screen.dart'; // Assuming you have HomeScreen defined

class EditProfileScreen extends StatefulWidget {
  final User user; // Assuming User is a defined class with necessary fields

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _fNameController;
  late TextEditingController _mNameController;
  late TextEditingController _preAddrController;
  late TextEditingController _prePhoneController;
  late TextEditingController _preEmailController;
  late TextEditingController _perAddrController;
  late TextEditingController _perPhoneController;
  late TextEditingController _perEmailController;
  late TextEditingController _officeNameController;
  late TextEditingController _offAddrController;
  late TextEditingController _offPhoneController;
  late TextEditingController _offEmailController;
  late TextEditingController _dobController;
  late TextEditingController _designationController;
  bool _isLoading = false;

  @override
  void initState() {
    getdata();
    super.initState();
    // Initialize controllers with user data
    _nameController = TextEditingController(text: widget.user.memName);
    _mobileController = TextEditingController(text: widget.user.memMobileNo);
    _fNameController = TextEditingController(text: widget.user.fName ?? '');
    _mNameController = TextEditingController(text: widget.user.mName ?? '');
    _preAddrController = TextEditingController(text: widget.user.preAddr ?? '');
    _prePhoneController = TextEditingController(text: widget.user.prePhone ?? '');
    _preEmailController = TextEditingController(text: widget.user.preEmail ?? '');
    _perAddrController = TextEditingController(text: widget.user.perAddr ?? '');
    _perPhoneController = TextEditingController(text: widget.user.perPhone ?? '');
    _perEmailController = TextEditingController(text: widget.user.perEmail ?? '');
    _officeNameController = TextEditingController(text: widget.user.officeName ?? '');
    _offAddrController = TextEditingController(text: widget.user.offAddr ?? '');
    _offPhoneController = TextEditingController(text: widget.user.offPhone ?? '');
    _offEmailController = TextEditingController(text: widget.user.offEmail ?? '');
    _dobController = TextEditingController(text: widget.user.dob ?? '');
    _designationController = TextEditingController(text: widget.user.designation ?? '');
  }

  String? savedPhone = "";
  String? savedPassword = "";
  String? username = "";
  String? usermemphoto = "";
  String? usercollrollname = "";

  void getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedPhone = prefs.getString('userphone') ?? '';
      savedPassword = prefs.getString('password') ?? '';
      username = prefs.getString("username") ?? '';
      usercollrollname = prefs.getString("usercollrollname") ?? '';
      usermemphoto = prefs.getString("usermemphoto") ?? '';
    });
  }

  Future<void> _updateUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Construct the updated user data
    final updatedUserData = {
      'mem_name': _nameController.text,
      'mem_mobile_no': _mobileController.text,
      'f_name': _fNameController.text,
      'm_name': _mNameController.text,
      'pre_addr': _preAddrController.text,
      'pre_phone': _prePhoneController.text,
      'pre_email': _preEmailController.text,
      'per_addr': _perAddrController.text,
      'per_phone': _perPhoneController.text,
      'per_email': _perEmailController.text,
      'office_name': _officeNameController.text,
      'off_addr': _offAddrController.text,
      'off_phone': _offPhoneController.text,
      'off_email': _offEmailController.text,
      'dob': _dobController.text,
      'designation': _designationController.text,
    };

    final response = await http.post(
      Uri.parse('http://103.106.118.10/ndc90_api/userupdate.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedUserData),
    );

    if (response.statusCode == 200) {
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      final updatedUser = User(
        memName: _nameController.text,
        memMobileNo: _mobileController.text,
        fName: _fNameController.text,
        mName: _mNameController.text,
        preAddr: _preAddrController.text,
        prePhone: _prePhoneController.text,
        preEmail: _preEmailController.text,
        perAddr: _perAddrController.text,
        perPhone: _perPhoneController.text,
        perEmail: _perEmailController.text,
        officeName: _officeNameController.text,
        offAddr: _offAddrController.text,
        offPhone: _offPhoneController.text,
        offEmail: _offEmailController.text,
        dob: _dobController.text,
        designation: _designationController.text,
        memId: '', // Add if needed
      );

      Navigator.pop(context, updatedUser); // Pass the updated user object
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController..text = "$username",
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _mobileController..text = "$savedPhone",
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: _fNameController,
                decoration: const InputDecoration(labelText: 'Father\'s Name'),
              ),
              TextField(
                controller: _mNameController,
                decoration: const InputDecoration(labelText: 'Mother\'s Name'),
              ),
              TextField(
                controller: _preAddrController,
                decoration: const InputDecoration(labelText: 'Present Address'),
              ),
              TextField(
                controller: _prePhoneController,
                decoration: const InputDecoration(labelText: 'Present Phone'),
              ),
              TextField(
                controller: _preEmailController,
                decoration: const InputDecoration(labelText: 'Present Email'),
              ),
              TextField(
                controller: _perAddrController,
                decoration: const InputDecoration(labelText: 'Permanent Address'),
              ),
              TextField(
                controller: _perPhoneController,
                decoration: const InputDecoration(labelText: 'Permanent Phone'),
              ),
              TextField(
                controller: _perEmailController,
                decoration: const InputDecoration(labelText: 'Permanent Email'),
              ),
              TextField(
                controller: _officeNameController,
                decoration: const InputDecoration(labelText: 'Office Name'),
              ),
              TextField(
                controller: _offAddrController,
                decoration: const InputDecoration(labelText: 'Office Address'),
              ),
              TextField(
                controller: _offPhoneController,
                decoration: const InputDecoration(labelText: 'Office Phone'),
              ),
              TextField(
                controller: _offEmailController,
                decoration: const InputDecoration(labelText: 'Office Email'),
              ),
              TextField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _designationController,
                decoration: const InputDecoration(labelText: 'Designation'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _updateUserData,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

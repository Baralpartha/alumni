import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // For JSON encoding/decoding
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Text controllers
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _rollNumberController = TextEditingController();
  final _yearOfPassController = TextEditingController();
  final _designationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();

  // Variables to control password visibility
  bool _isPasswordVisible = false;
  bool _isRetypePasswordVisible = false;

  // Dropdown variable
  String? _selectedCategory; // Holds the selected category value
  final Map<String, String> _categories = {
    'Science(Bangla)': '1',
    'Science(Eng. Version)': '2',
    'Business Studies': '4',
    'Humanities': '3',
  }; // Dropdown options with corresponding codes

  Future<void> _signup() async {
    String username = _usernameController.text;
    String phoneNumber = _phoneController.text;
    String email = _emailController.text;
    String rollNumber = _rollNumberController.text;
    String catCode = _categories[_selectedCategory] ?? ''; // Get the selected category code
    String yearOfPass = _yearOfPassController.text;
    String designation = _designationController.text;
    String password = _passwordController.text;
    String retypePassword = _retypePasswordController.text;

    // Validate input
    if (username.isEmpty ||
        phoneNumber.isEmpty ||
        email.isEmpty ||
        rollNumber.isEmpty ||
        catCode.isEmpty ||
        yearOfPass.isEmpty ||
        designation.isEmpty ||
        password.isEmpty ||
        retypePassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    // Simple email validation
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email.')),
      );
      return;
    }

    if (password != retypePassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    // Make the API request
    try {
      final response = await http.post(
        Uri.parse('http://103.106.118.10/ndc90_api/singup.php'), // Update this with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'signup', // Include action
          'name': username,
          'mobileNo': phoneNumber,
          'rollNo': rollNumber,
          'catCode': catCode, // Pass the category code
          'yrOfPass': yearOfPass,
          'email': email,
          'designation': designation,
          'password': password // Assuming the API requires password
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully')),
        );

        // Optionally navigate back to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while signing up.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _rollNumberController,
              decoration: InputDecoration(
                labelText: 'Roll Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _categories.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              validator: (value) => value == null ? 'Please select a category' : null,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _yearOfPassController,
              decoration: InputDecoration(
                labelText: 'Year of Passing',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _designationController,
              decoration: InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _retypePasswordController,
              obscureText: !_isRetypePasswordVisible,
              decoration: InputDecoration(
                labelText: 'Retype Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isRetypePasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isRetypePasswordVisible = !_isRetypePasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signup, // Call the signup function
                child: const Text('Continue'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

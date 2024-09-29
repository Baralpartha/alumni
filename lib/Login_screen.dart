import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile_screen.dart'; // Import the UserProfileScreen
import 'Home_screen.dart'; // Import the HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPhone = prefs.getString('phone');
    String? savedPassword = prefs.getString('password');

    if (savedPhone != null) {
      _phoneController.text = savedPhone;
    }
    if (savedPassword != null) {
      _passwordController.text = savedPassword;
    }
  }

  Future<void> _loginUser() async {
    final String phone = _phoneController.text.trim();
    final String password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showErrorDialog('Phone number and password are required.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String apiUrl = 'http://103.106.118.10/ndc90_api/login.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'action': 'login',
          'mobileNo': phone,
          'userPass': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data');

        if (data['status'] == 'success') {
          // Safely extract user data from response
          String username = data['user']['mem_name'] ?? 'Unknown User';
          String memId = data['user']['mem_id']?.toString() ?? 'Unknown ID';
          String memMobileNo = data['user']['mem_mobile_no']?.toString() ?? 'Unknown Mobile';
          String collRollNo = data['user']['coll_roll_no']?.toString() ?? 'Unknown Roll No';
          String? memPhoto = data['user']['mem_photo'];

          // Save credentials if successful
          await _saveCredentials(phone, password);

          // Navigate to HomeScreen with user data and username
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                user: {
                  'name': username,
                  'memId': memId,
                  'phone': memMobileNo,
                  'collRollNo': collRollNo,
                  'memPhoto': memPhoto ?? '', // Default to empty string if null
                },
              ),
            ),
          );
        } else {
          _showErrorDialog(data['message']);
        }
      } else {
        _showErrorDialog('Login failed. Please try again.');
      }
    } catch (e) {
      print('Error during login: $e');
      _showErrorDialog('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCredentials(String phone, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phone);
    await prefs.setString('password', password);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sign in to continue!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 40),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

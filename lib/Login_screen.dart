import 'dart:convert';
import 'package:alumni/profession_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Home_screen.dart';
import 'Singup_screen.dart';

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

  String savedPhone = "";
  String savedPass = "";

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPhone = prefs.getString('phone');
    String? savedPassword = prefs.getString('password');

    if (savedPhone != null && savedPassword != null) {
      _phoneController.text = savedPhone;
      _passwordController.text = savedPassword;
    }
  }

  Future<void> _loginUser(String phone, String password) async {
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
          'MEM_MOBILE_NO': phone,
          'userPass': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API Response: $data');

        if (data['status'] == 'success') {
          // Extract user information with fallback values
          String username = data['user']['mem_name'] ?? 'Unknown User';
          String memId = data['user']['mem_id']?.toString() ?? 'Unknown ID';
          String memMobileNo = data['user']['mem_mobile_no']?.toString() ??
              'Unknown Mobile';
          String memPhoto = data['user']['mem_photo'] ?? 'Unknown Photo';
          String collRollNo = data['user']['coll_roll_no']?.toString() ??
              'Unknown Roll No';
          String catCode = data['user']['cat_code'] ?? 'Unknown Category Code';
          String collSec = data['user']['coll_sec'] ?? 'Unknown Section';
          String yrOfPass = data['user']['yr_of_pass'] ??
              'Unknown Year of Passing';
          String fName = data['user']['f_name'] ?? 'Unknown Father Name';
          String mName = data['user']['m_name'] ?? 'Unknown Mother Name';
          String preAddr = data['user']['pre_addr'] ??
              'Unknown Present Address';
          String preDiv = data['user']['pre_div'] ?? 'Unknown Present Division';
          String preDist = data['user']['pre_dist'] ??
              'Unknown Present District';
          String preThana = data['user']['pre_thana'] ??
              'Unknown Present Thana';
          String prePhone = data['user']['pre_phone']?.toString() ??
              'Unknown Present Phone';
          String preEmail = data['user']['pre_email'] ??
              'Unknown Present Email';
          String perAddr = data['user']['per_addr'] ??
              'Unknown Permanent Address';
          String perDiv = data['user']['per_div'] ??
              'Unknown Permanent Division';
          String perDist = data['user']['per_dist'] ??
              'Unknown Permanent District';
          String perThana = data['user']['per_thana'] ??
              'Unknown Permanent Thana';
          String perPhone = data['user']['per_phone']?.toString() ??
              'Unknown Permanent Phone';
          String perEmail = data['user']['per_email'] ??
              'Unknown Permanent Email';
          String profCode = data['user']['prof_code'] ??
              'Unknown Profession Code';
          String designation = data['user']['designation'] ??
              'Unknown Designation';
          String officeName = data['user']['office_name'] ??
              'Unknown Office Name';
          String offAddr = data['user']['off_addr'] ?? 'Unknown Office Address';
          String offDiv = data['user']['off_div'] ?? 'Unknown Office Division';
          String offDist = data['user']['off_dist'] ??
              'Unknown Office District';
          String offThana = data['user']['off_thana'] ?? 'Unknown Office Thana';
          String offPhone = data['user']['off_phone']?.toString() ??
              'Unknown Office Phone';
          String offEmail = data['user']['off_email'] ?? 'Unknown Office Email';
          String dob = data['user']['dob'] ?? 'Unknown DOB';
          String dom = data['user']['dom'] ?? 'Unknown DOM';
          String prePostCode = data['user']['pre_post_code'] ??
              'Unknown Present Post Code';
          String memType = data['user']['mem_type'] ?? 'Unknown Member Type';
          String bloodGroupCode = data['user']['BG'] ?? '';

          // Save user data to SharedPreferences
          final pref = await SharedPreferences.getInstance();
          await pref.setString("memid", memId);
          await pref.setString("memphoto", memPhoto);
          await pref.setString("userphone", memMobileNo);
          await pref.setString("username", username);
          await pref.setString("usercollrollname", collRollNo);
          await pref.setString("usercatcode", catCode);
          await pref.setString("usercollsec", collSec);
          await pref.setString("yearofpass", yrOfPass);
          await pref.setString("fathername", fName);
          await pref.setString("mothername", mName);
          await pref.setString("presentaddress", preAddr);
          await pref.setString("presentdiv", preDiv);
          await pref.setString("presentdist", preDist);
          await pref.setString("presentthana", preThana);
          await pref.setString("presentphone", prePhone);
          await pref.setString("presentemail", preEmail);
          await pref.setString("permanentaddress", perAddr);
          await pref.setString("permanentdiv", perDiv);
          await pref.setString("permanentdist", perDist);
          await pref.setString("permanentthana", perThana);
          await pref.setString("permanentphone", perPhone);
          await pref.setString("permanentemail", perEmail);
          await pref.setString("profcode", profCode);
          await pref.setString("designation", designation);
          await pref.setString("officename", officeName);
          await pref.setString("officeaddress", offAddr);
          await pref.setString("officediv", offDiv);
          await pref.setString("officedist", offDist);
          await pref.setString("officethana", offThana);
          await pref.setString("officephone", offPhone);
          await pref.setString("officeemail", offEmail);
          await pref.setString("dob", dob);
          await pref.setString("dom", dom);
          await pref.setString("pre_post_code", prePostCode);
          await pref.setString("membertype", memType);
          await pref.setString("bloodgroup",bloodGroupCode);


          print('Pre District ================================== ${profCode}');
          print('----------------------------$memPhoto ---------------------------');


          // Save credentials if successful
          await _saveCredentials(phone, password);

          // Navigate to HomeScreen with user data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(
                    user: {
                      'name': username,
                      'memId': memId,
                      'phone': memMobileNo,
                      'collRollNo': collRollNo,
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
      builder: (ctx) =>
          AlertDialog(
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

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: const Text('Forgot Password'),
            content: const Text(
                'Instructions to reset your password have been sent to your registered email.'),
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 70), // Space between text and image

            // Circular Image
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/ndccc.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between image and text

            // Phone Number TextField
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons
                        .visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Login Button
            Center(
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8, // Responsive width
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000),
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () {
                      _loginUser(_phoneController.text.trim(),
                          _passwordController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF48c9b0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Forgot Password Button
            TextButton(
              onPressed: _forgotPassword,
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),

            // Sign Up Button
            Center(
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.3, // Responsive width
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000),
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _navigateToSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF27ae60),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 55), // Space before images

            // Image below Sign Up Button
            Center(
              child: Container(
                width: 100, // Image width
                height: 100, // Image height
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/logooo.png'),
                    // Your image path here
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), // Adjust this space as needed
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: const Color(0xFF7dcea0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Powered by:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'IT Bangla Limited',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
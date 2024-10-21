import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'EditProfileScreen.dart';
import 'Home_screen.dart';

class UserLogin {
  //User? loggedInUser;
  // Define the login method
  static Future<void> loginUser(BuildContext context, String phone, String password) async {
    if (phone.isEmpty || password.isEmpty) {
      //_showErrorDialog(context, 'Phone number and password are required.');
      return;
    }

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
          // Extract user information
          String username = data['user']['mem_name'] ?? 'Unknown User';
          String memId = data['user']['mem_id']?.toString() ?? 'Unknown ID';
          String memMobileNo = data['user']['mem_mobile_no']?.toString() ?? 'Unknown Mobile';
          String memPhoto = data['user']['mem_photo'] ?? 'Unknown Photo';
          String collRollNo = data['user']['coll_roll_no']?.toString() ?? 'Unknown Roll No';
          String catCode = data['user']['cat_code'] ?? 'Unknown Category Code';
          String collSec = data['user']['coll_sec'] ?? 'Unknown Section';
          String yrOfPass = data['user']['yr_of_pass'] ?? 'Unknown Year of Passing';
          String fName = data['user']['f_name'] ?? 'Unknown Father Name';
          String mName = data['user']['m_name'] ?? 'Unknown Mother Name';
          String preAddr = data['user']['pre_addr'] ?? 'Unknown Present Address';
          String preDiv = data['user']['pre_div'] ?? 'Unknown Present Division';
          String preDist = data['user']['pre_dist'] ?? 'Unknown Present District';
          String preThana = data['user']['pre_thana'] ?? 'Unknown Present Thana';
          String prePhone = data['user']['pre_phone']?.toString() ?? 'Unknown Present Phone';
          String preEmail = data['user']['pre_email'] ?? 'Unknown Present Email';
          String perAddr = data['user']['per_addr'] ?? 'Unknown Permanent Address';
          String perDiv = data['user']['per_div'] ?? 'Unknown Permanent Division';
          String perDist = data['user']['per_dist'] ?? 'Unknown Permanent District';
          String perThana = data['user']['per_thana'] ?? 'Unknown Permanent Thana';
          String perPhone = data['user']['per_phone']?.toString() ?? 'Unknown Permanent Phone';
          String perEmail = data['user']['per_email'] ?? 'Unknown Permanent Email';
          String profCode = data['user']['prof_code'] ?? 'Unknown Profession Code';
          String designation = data['user']['designation'] ?? 'Unknown Designation';
          String officeName = data['user']['office_name'] ?? 'Unknown Office Name';
          String offAddr = data['user']['off_addr'] ?? 'Unknown Office Address';
          String offDiv = data['user']['off_div'] ?? 'Unknown Office Division';
          String offDist = data['user']['off_dist'] ?? 'Unknown Office District';
          String offThana = data['user']['off_thana'] ?? 'Unknown Office Thana';
          String offPhone = data['user']['off_phone']?.toString() ?? 'Unknown Office Phone';
          String offEmail = data['user']['off_email'] ?? 'Unknown Office Email';
          String dob = data['user']['dob'] ?? 'Unknown DOB';
          String dom = data['user']['dom'] ?? 'Unknown DOM';
          String prePostCode = data['user']['pre_post_code'] ?? 'Unknown Present Post Code';
          String memType = data['user']['mem_type'] ?? 'Unknown Member Type';
          // Extract and set the BG field
          String bg = data['user']['BG'] ?? 'No Blood Group'; // Use the same format as memType
          String spouseName = data['user']['spouse_name'] ?? '';



          // Save user data to SharedPreferences
          final pref = await SharedPreferences.getInstance();
          await pref.setString("bg", bg); // Save the BG field await pref.setString("bg", bg); // Save the BG field
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
          await pref.setString("bg", bg); // Save the BG field
          await pref.setString("spouseName", spouseName);

          // Create a User object with the fetched data
          User loggedInUser = User(
            memId: memId,
            memName: username,
            memMobileNo: memMobileNo,
            memPhoto: memPhoto,
            collRollNo: collRollNo,
            yrOfPass: yrOfPass,
          );

          // Save credentials if successful
          await _saveCredentials(phone, password);

          // Navigate to HomeScreen with user data
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HomeScreen(
          //       user: {
          //         'name': username,
          //         'memId': memId,
          //         'phone': memMobileNo,
          //         'collRollNo': collRollNo,
          //       },
          //     ),
          //   ),
          // );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditProfileScreen(user: loggedInUser),
            ),
          );
        } else {
        }
      } else {
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }

  // Save login credentials
  static Future<void> _saveCredentials(String phone, String password) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('userPhone', phone);
    await pref.setString('userPassword', password);
  }
}

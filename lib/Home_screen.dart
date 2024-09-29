import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String memId;
  final String? memPhoto;
  final String memName;
  final String memMobileNo;
  final String? collRollNo;
  final String? catCode;
  final String? collSec;
  final String? yrOfPass;
  final String? fName;
  final String? mName;
  final String? preAddr;
  final String? preDiv;
  final String? preDist;
  final String? preThana;
  final String? prePhone;
  final String? preEmail;
  final String? perAddr;
  final String? perDiv;
  final String? perDist;
  final String? perThana;
  final String? profCode;
  final String? designation;
  final String? officeName;
  final String? offAddr;
  final String? offDiv;
  final String? offDist;
  final String? offThana;
  final String? offPhone;
  final String? offEmail;
  final String? memType;
  final String? dob;
  final String? dom;
  final String? lmNo;

  User({
    required this.memId,
    this.memPhoto,
    required this.memName,
    required this.memMobileNo,
    this.collRollNo,
    this.catCode,
    this.collSec,
    this.yrOfPass,
    this.fName,
    this.mName,
    this.preAddr,
    this.preDiv,
    this.preDist,
    this.preThana,
    this.prePhone,
    this.preEmail,
    this.perAddr,
    this.perDiv,
    this.perDist,
    this.perThana,
    this.profCode,
    this.designation,
    this.officeName,
    this.offAddr,
    this.offDiv,
    this.offDist,
    this.offThana,
    this.offPhone,
    this.offEmail,
    this.memType,
    this.dob,
    this.dom,
    this.lmNo,
  });

  // Factory method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      memId: json['MEM_ID'] ?? '',
      memPhoto: json['MEM_PHOTO']?.toString(),
      memName: json['MEM_NAME'] ?? '',
      memMobileNo: json['MEM_MOBILE_NO'] ?? '',
      collRollNo: json['COLL_ROLL_NO'],
      catCode: json['CAT_CODE'],
      collSec: json['COLL_SEC'],
      yrOfPass: json['YR_OF_PASS'],
      fName: json['F_NAME'],
      mName: json['M_NAME'],
      preAddr: json['PRE_ADDR'],
      preDiv: json['PRE_DIV'],
      preDist: json['PRE_DIST'],
      preThana: json['PRE_THANA'],
      prePhone: json['PRE_PHONE'],
      preEmail: json['PRE_EMAIL'],
      perAddr: json['PER_ADDR'],
      perDiv: json['PER_DIV'],
      perDist: json['PER_DIST'],
      perThana: json['PER_THANA'],
      profCode: json['PROF_CODE'],
      designation: json['DESIGNATION'],
      officeName: json['OFFICE_NAME'],
      offAddr: json['OFF_ADDR'],
      offDiv: json['OFF_DIV'],
      offDist: json['OFF_DIST'],
      offThana: json['OFF_THANA'],
      offPhone: json['OFF_PHONE'],
      offEmail: json['OFF_EMAIL'],
      memType: json['MEM_TYPE'],
      dob: json['DOB'],
      dom: json['DOM'],
      lmNo: json['LM_NO'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Map<String, String> user; // User data map

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> userList = []; // List to hold User objects
  List<User> filteredUserList = []; // List to hold filtered User objects

  @override
  void initState() {
    super.initState();
    _fetchUserList(); // Fetch user list when the widget is initialized
  }

  Future<void> _fetchUserList() async {
    try {
      final response = await http.get(Uri.parse('http://103.106.118.10/ndc90_api/userdata.php'));

      if (response.statusCode == 200) {
        final rawString = response.body;

        // Clean up the response to convert it into a valid JSON string
        String jsonString = _convertResponseToJson(rawString);

        final List<dynamic> data = json.decode(jsonString);

        setState(() {
          userList = data.map((json) => User.fromJson(json)).toList(); // Parse JSON to User list
          filteredUserList = userList; // Initialize filtered list
        });
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  String _convertResponseToJson(String rawString) {
    // Replace 'Array' and unnecessary symbols to make it JSON-like
    String jsonString = rawString
        .replaceAllMapped(RegExp(r'\[([A-Za-z0-9_]+)\]'), (match) => '"${match[1]}":') // Replace [KEY] with "KEY":
        .replaceAllMapped(RegExp(r'=>'), (match) => ':') // Replace => with :
        .replaceAll(RegExp(r'(\r\n|\r|\n|\s+|\(|\))'), '') // Remove newlines, spaces, (), etc.
        .replaceAll('OCILobObject', 'null'); // Replace OCILob Object with null

    // Wrap with { } to create a valid JSON string if necessary
    if (!jsonString.startsWith('{')) {
      jsonString = '{$jsonString}';
    }

    return jsonString;
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUserList = userList.where((user) {
        return user.memName.toLowerCase().contains(query.toLowerCase()) ||
            user.memMobileNo.contains(query);
      }).toList();
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
              _logout(); // Call the logout function
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<bool> _onWillPop() async {
    _showLogoutDialog();
    return false; // Prevent the default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Members'),
          backgroundColor: Colors.greenAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _showLogoutDialog,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: _filterUsers, // Call the filter method on text change
              ),
              const SizedBox(height: 20),
              // User List
              Expanded(
                child: filteredUserList.isNotEmpty
                    ? ListView.builder(
                  itemCount: filteredUserList.length,
                  itemBuilder: (context, index) {
                    User user = filteredUserList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(user.memName),
                        subtitle: Text(user.memMobileNo),
                        onTap: () {
                          // Handle tap event to navigate or show user details
                        },
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text('No members found.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'login_screen.dart';
import 'EditProfileScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String memId; // Add this property
  final String memName;
  final String memMobileNo;
  final String? fName;
  final String? mName;
  final String? preAddr;
  final String? prePhone;
  final String? preEmail;
  final String? perAddr;
  final String? perPhone;
  final String? perEmail;
  final String? officeName;
  final String? offAddr;
  final String? offPhone;
  final String? offEmail;
  final String? dob;
  final String? designation;
  final String? memPhoto; // Add this property
  final String? collRollNo; // Add this property
  final String? yrOfPass; // Add this property

  User({
    required this.memId, // Update constructor
    required this.memName,
    required this.memMobileNo,
    this.fName,
    this.mName,
    this.preAddr,
    this.prePhone,
    this.preEmail,
    this.perAddr,
    this.perPhone,
    this.perEmail,
    this.officeName,
    this.offAddr,
    this.offPhone,
    this.offEmail,
    this.dob,
    this.designation,
    this.memPhoto,
    this.collRollNo,
    this.yrOfPass,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      memId: json['MEM_ID'] ?? '', // Ensure to include this in the factory
      memPhoto: json['MEM_PHOTO']?.toString(), // Include this in the factory
      memName: json['MEM_NAME'] ?? '',
      memMobileNo: json['MEM_MOBILE_NO'] ?? '',
      fName: json['F_NAME'],
      mName: json['M_NAME'],
      preAddr: json['PRE_ADDR'],
      prePhone: json['PRE_PHONE'],
      preEmail: json['PRE_EMAIL'],
      perAddr: json['PER_ADDR'],
      perPhone: json['PER_PHONE'],
      perEmail: json['PER_EMAIL'],
      officeName: json['OFFICE_NAME'],
      offAddr: json['OFF_ADDR'],
      offPhone: json['OFF_PHONE'],
      offEmail: json['OFF_EMAIL'],
      dob: json['DOB'],
      designation: json['DESIGNATION'],
      collRollNo: json['COLL_ROLL_NO'],
      yrOfPass: json['YR_OF_PASS'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Map<String, String> user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> userList = [];
  List<User> filteredUserList = [];
  int _currentIndex = 1;
  bool _isLoading = true;

  // Store the logged-in user info
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    _fetchUserList();
    _getLoggedInUserData(); // Fetch logged-in user data
  }

  Future<void> _fetchUserList() async {
    try {
      final response = await http.get(Uri.parse('http://103.106.118.10/ndc90_api/userdata.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          userList = data.map((json) => User.fromJson(json)).toList();
          filteredUserList = userList; // Initialize with all users
          _isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        print('Failed to load user data: ${response.statusCode}');
        setState(() {
          _isLoading = false; // Set loading to false on error
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false; // Set loading to false on error
      });
    }
  }

  // Fetch the logged-in user's data from SharedPreferences
  // Fetch the logged-in user's data from SharedPreferences
  void _getLoggedInUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUser = User(
        memId: prefs.getString('memId') ?? '',
        memName: prefs.getString('memName') ?? '',
        memMobileNo: prefs.getString('memMobileNo') ?? '',
        memPhoto: prefs.getString('memPhoto'),
        collRollNo: prefs.getString('collRollNo'),
        yrOfPass: prefs.getString('yrOfPass'),
      );
    });

    // Debugging
    print('Saved User Data: ${prefs.getString('memId')}, ${prefs.getString('memName')}, ${prefs.getString('memMobileNo')}');

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
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _logout();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('phone');
    await prefs.remove('password');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<bool> _onWillPop() async {
    _showLogoutDialog();
    return false;
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
          child: _isLoading // Show CircularProgressIndicator when loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: <Widget>[
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: _filterUsers,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: filteredUserList.isEmpty
                    ? const Center(child: Text('No members found.'))
                    : ListView.builder(
                  itemCount: filteredUserList.length,
                  itemBuilder: (context, index) {
                    User user = filteredUserList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: user.memPhoto != null
                            ? CircleAvatar(
                          backgroundImage:
                          NetworkImage(user.memPhoto!),
                          radius: 25,
                        )
                            : const CircleAvatar(
                          child: Icon(Icons.person),
                          radius: 25,
                        ),
                        title: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(user.memName)),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                        subtitle: GestureDetector(
                          onTap: () async {
                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path: user.memMobileNo,
                            );
                            await launch(launchUri.toString());
                          },
                          child: Text(
                            user.memMobileNo,
                            style:
                            const TextStyle(color: Colors.blue),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserProfileScreen(user: user),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_album), label: 'Gallery'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 2) {
                // Navigate to EditProfileScreen only if loggedInUser is not null
                if (loggedInUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(user: loggedInUser!),
                    ),
                  );
                } else {
                  // Optionally show an error message or redirect to the login screen
                  print('No logged-in user data available.');
                }
              }

            });
          },
        ),
      ),
    );
  }
}

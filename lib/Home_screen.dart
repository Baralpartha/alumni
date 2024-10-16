import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'login_screen.dart';
import 'EditProfileScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data'; // for handling binary data

class User {
  final String memId;
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
  final String? memPhoto; // This will hold the base64 image data
  final String? collRollNo;
  final String? yrOfPass;
  final String? catCode;
  final String? collSec;
  final String? dom;
  final String? preDiv;
  final String? preDist;
  final String? preThana;
  final String? perDist;
  final String? perThana;
  final String? profCode;
  final String? prePostCode;
  final String? perDiv;
  final String? memType;

  User({
    required this.memId,
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
    this.catCode,
    this.collSec,
    this.dom,
    this.preDiv,
    this.preDist,
    this.preThana,
    this.perDist,
    this.perThana,
    this.profCode,
    this.prePostCode,
    this.perDiv,
    this.memType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      memId: json['MEM_ID'] ?? '',
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
      memPhoto: json['MEM_PHOTO'], // base64 image data
      collRollNo: json['COLL_ROLL_NO'],
      yrOfPass: json['YR_OF_PASS'],
      catCode: json['CAT_CODE'],
      collSec: json['COLL_SEC'],
      dom: json['Date_of_Membership'],
      preDiv: json['PRE_DIV'],
      preDist: json['PRE_DIST'],
      preThana: json['PRE_THANA'],
      perDist: json['PER_DIST'],
      perThana: json['PER_THANA'],
      profCode: json['PROF_CODE'],
      prePostCode: json['PRE_POST_CODE'],
      perDiv: json['PER_DIV'],
      memType: json['MEM_TYPE'],
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

  // Dropdown filter options
  String? selectedFilter;
  final List<String> filterOptions = [
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserList();
    _getLoggedInUserData(); // Fetch logged-in user data
  }

  Future<void> _fetchUserList() async {
    try {
      final response = await http.get(
          Uri.parse('http://103.106.118.10/ndc90_api/userdata.php'));

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

  void _filterUsers(String query) {
    setState(() {
      filteredUserList = userList.where((user) {
        final matchesQuery = user.memName.toLowerCase().contains(
            query.toLowerCase()) ||
            user.memMobileNo.contains(query);
        final matchesFilter = selectedFilter == null || selectedFilter == 'All'
            ? true // Show all if 'All' is selected
            : user.designation ==
            selectedFilter; // Adjust this to your criteria
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

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
    print('Saved User Data: ${prefs.getString('memId')}, ${prefs.getString(
        'memName')}, ${prefs.getString('memMobileNo')}');
  }

  String fixBase64(String base64) {
    if (base64.contains(',')) {
      base64 = base64
          .split(',')
          .last; // Removes 'data:image/jpeg;base64,' if present
    }
    base64 = base64.replaceAll(RegExp(r'\s+'), ''); // Remove whitespaces

    // Ensure valid Base64 string length
    int padding = base64.length % 4;
    if (padding != 0) {
      base64 += '=' * (4 - padding);
    }
    return base64;
  }

  Uint8List? decodeBase64(String base64) {
    try {
      return base64Decode(base64);
    } catch (e) {
      print('Error decoding Base64: $e');
      return null; // Return null if decoding fails
    }
  }


  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.remove('phone');
    //await prefs.remove('password');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<bool> _onWillPop() async {
    //_showLogoutDialog();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    return false;
  }

  // Helper function to build user avatar
  Widget _buildUserAvatar(String base64Image) {
    try {
      // Fix and decode the Base64 string
      Uint8List? decodedImage = decodeBase64(fixBase64(base64Image));

      if (decodedImage != null) {
        return CircleAvatar(
          backgroundImage: MemoryImage(decodedImage),
        );
      } else {
        return const CircleAvatar(
            child: Icon(Icons.person)); // Fallback if decoding fails
      }
    } catch (e) {
      print('Error decoding image: $e');
      return const CircleAvatar(
          child: Icon(Icons.person)); // Fallback in case of any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Alapon-NDC90',
            style: TextStyle(
              fontSize: 20, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Makes the text bold
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Adjust the radius as needed
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            // Show the filter options when the icon is clicked
                            _showFilterOptions(context);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (query) {
                        _filterUsers(query);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                        leading: user.memPhoto != null &&
                            user.memPhoto!.isNotEmpty
                            ? _buildUserAvatar(user.memPhoto!)
                            : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(user.memName),
                        subtitle: Text(user.memMobileNo),
                        trailing: IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () async {
                            final phoneUrl = 'tel:${user.memMobileNo}';
                            if (await canLaunch(phoneUrl)) {
                              await launch(phoneUrl);
                            } else {
                              throw 'Could not launch $phoneUrl';
                            }
                          },
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
                if (loggedInUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(user: loggedInUser!),
                    ),
                  );
                } else {
                  print('No logged-in user data available.');
                }
              }
            });
          },
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _showSubFilterOptions(context, 'all');
                },
              ),
              ListTile(
                title: const Text('Group'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _showSubFilterOptions(context, 'Group');
                },
              ),
              ListTile(
                title: const Text('Profession'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _showSubFilterOptions(context, 'Profession');
                },
              ),
              ListTile(
                title: const Text('Blood Group'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _showSubFilterOptions(context, 'Blood Group');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSubFilterOptions(BuildContext context, String filterCategory) {
    List<String> subOptions = [];

    // Define sub-options based on the category selected
    if (filterCategory == 'Group') {
      subOptions = [
        'All', // Always first
        'Humanities',
        'Business Studies',
        'Science(Eng. Version)',
        'Science(Bangla)',
      ];
    } else if (filterCategory == 'Profession') {
      subOptions = [
        'All', // Always first
        'Doctor',
        'Engineer',
        'Banker',
        'Businessman',
      ];
    } else if (filterCategory == 'Blood Group') {
      subOptions = [
        'All', // Always first
        'AB+',
        'O+',
        'A+',
        'B+',
      ];
    }

    // Show a dialog with sub-options based on the selected category
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select $filterCategory'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: subOptions.map((String option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  setState(() {
                    if (option == 'All') {
                      // Handle "All" option to show all users
                      selectedFilter = null; // Reset the filter
                      _filterUsers(''); // Pass an empty string to show all users
                    } else {
                      selectedFilter = option; // Set the selected filter
                      _filterUsers(_searchController.text); // Apply the filter
                    }
                  });
                  Navigator.pop(context); // Close the sub-filter dialog
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
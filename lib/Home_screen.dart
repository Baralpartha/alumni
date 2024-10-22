import 'package:alumni/profession_list.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'user_profile_screen.dart';
import 'login_screen.dart';
import 'EditProfileScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data'; // for handling binary data
import 'logout/log_out.dart';

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
  final String? bloodGroupCode;
  final String? spouseName;
  final String? spouseDob;
  final String? spouseProf;

  final String? child1Name;
  final String? child1Gender;
  final String? child1Dob;

  final String? child2Name;
  final String? child2Gender;
  final String? child2Dob;

  final String? child3Name;
  final String? child3Gender;
  final String? child3Dob;

  final String? child4Name;
  final String? child4Gender;
  final String? child4Dob;

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
    this.bloodGroupCode,

    //New fild
    this.spouseName,
    this.spouseDob,
    this.spouseProf,
    this.child1Name,
    this.child1Gender,
    this.child1Dob,
    this.child2Name,
    this.child2Gender,
    this.child2Dob,
    this.child3Name,
    this.child3Gender,
    this.child3Dob,
    this.child4Name,
    this.child4Gender,
    this.child4Dob,
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
      bloodGroupCode: json['BG'],



      //new field
      spouseName: json['SPOUSE_NAME'],
      spouseDob: json['SPOUSE_DOB'],
      spouseProf: json['SPOUSE_PROF'],
      child1Name: json['CHIELD1_NAME'],
      child1Gender: json['CHIELD1_GENDER'],
      child1Dob: json['CHIELD1_DOB'],
      child2Name: json['CHIELD2_NAME'],
      child2Gender: json['CHIELD2_GENDER'],
      child2Dob: json['CHIELD2_DOB'],
      child3Name: json['CHIELD3_NAME'],
      child3Gender: json['CHIELD3_GENDER'],
      child3Dob: json['CHIELD3_DOB'],
      child4Name: json['CHIELD4_NAME'],
      child4Gender: json['CHIELD4_GENDER'],
      child4Dob: json['CHIELD4_DOB'],

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

  List<String> selectedGroupFilters = [];
  List<String> selectedProfessionFilters = [];
  List<String> selectedBloodGroupFilters = [];

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
        // Ensure that the profCode is 4 digits by padding with leading zeros, handling null values safely
        final formattedProfCode = (user.profCode ?? '').padLeft(4, '0');

        final matchesQuery = (user.memName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (user.memMobileNo?.contains(query) ?? false);

        // Check if the user matches any selected filters, handling null values safely
        final matchesGroupFilter = selectedGroupFilters.isEmpty || selectedGroupFilters.contains(user.catCode);
        final matchesProfessionFilter = selectedProfessionFilters.isEmpty || selectedProfessionFilters.contains(formattedProfCode);
        final matchesBloodGroupFilter = selectedBloodGroupFilters.isEmpty || selectedBloodGroupFilters.contains(user.bloodGroupCode);

        return matchesQuery && matchesGroupFilter && matchesProfessionFilter && matchesBloodGroupFilter;
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


  // Helper method to get profession description based on code
  String getProfessionDescription(String code) {
    for (var profession in professions) {
      if (profession['PROF_CODE'] == code) {
        return profession['PROF_DESC'] ?? ''; // Return empty string if description is null
      }
    }
    return ''; // Return empty string if profession is not found
  }


  // Function to get category description based on category code
  String getCategoryDescription(String code) {
    // Check if the code is empty or null and return an empty string
    if (code.isEmpty) {
      return '';
    }

    // Iterate through the list of groups
    for (var group in group) {
      // Check if the current group code matches the input code
      if (group['CAT_CODE'] == code) {
        // Return the description if available, otherwise return an empty string
        return group['CAT_DESC'] ?? '';
      }
    }

    // Return an empty string if the category is not found
    return '';
  }

  // Helper method to get blood group description based on code
  String getBloodGroupDescription(String code) {
    for (var blood in bloodGroup) {
      if (blood['BLOOD_CODE'] == code) {
        return blood['BLOOD_DESC'] ?? ''; // Return empty string if description is null
      }
    }
    return ''; // Return empty string if blood group is not found
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Prevents the back arrow icon from appearing
          title: const Text(
            'Alapon-NDC90',
            style: TextStyle(
              fontSize: 20, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Makes the text bold
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Adjust the radius as needed
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                LogoutDialog.showLogoutDialog(context); // Call the logout dialog function
              },
              child: const Text(
                'LogOut',
                style: TextStyle(
                  color: Color(0xFFE5214E),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )

            ),
          ],
        ),




        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Member: ', // Label for the user count
                    style: TextStyle(
                      fontSize: 16, // Adjust font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    filteredUserList.length.toString(), // Display user count
                    style: const TextStyle(
                      fontSize: 16, // Adjust font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                        leading: Container(
                          width: 50.0, // Set the desired width
                          height: 60.0, // Set the desired height
                          child: user.memPhoto != null && user.memPhoto!.isNotEmpty
                              ? _buildUserAvatar(user.memPhoto!)
                              : const CircleAvatar(child: Icon(Icons.person)),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                user.memName, // Display user name
                                style: TextStyle(
                                  fontSize: 18, // Base font size
                                  color: Colors.blue, // Name color
                                ),
                                maxLines: 1, // Ensure the name stays on one line
                                minFontSize: 12, // Auto adjust font size if the name is too long
                                overflow: TextOverflow.ellipsis, // Handle overflow for long names
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.memMobileNo, // Display mobile number
                              style: TextStyle(
                                fontSize: 16, // Font size for the number
                                color: Colors.green, // Mobile number color
                              ),
                            ),
                            Text(getProfessionDescription(user.profCode ?? '')), // Profession description
                            Text(getCategoryDescription(user.catCode ?? '')), // Category description
                            Text(
                              getBloodGroupDescription(user.bloodGroupCode ?? ''),
                              style: TextStyle(
                                fontSize: 16, // Font size for the blood group
                                color: Colors.red, // Set text color to red
                              ),
                            ),
                          ],
                        ),
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
                              builder: (context) => UserProfileScreen(user: user),
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
            BottomNavigationBarItem(icon: Icon(Icons.photo_album), label: 'Gallery'),
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
                      builder: (context) => EditProfileScreen(user: loggedInUser!),
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
                title: const Text('Group'),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () {
                  Navigator.pop(context);
                  _showSubFilterOptions(context, 'Group', selectedGroupFilters, (newSelection) {
                    setState(() {
                      selectedGroupFilters = newSelection;
                      _filterUsers(_searchController.text);
                    });
                  });
                },
              ),
              ListTile(
                title: const Text('Profession'),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () {
                  Navigator.pop(context);
                  _showSubFilterOptions(context, 'Profession', selectedProfessionFilters, (newSelection) {
                    setState(() {
                      selectedProfessionFilters = newSelection;
                      _filterUsers(_searchController.text);
                    });
                  });
                },
              ),
              ListTile(
                title: const Text('Blood Group'),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () {
                  Navigator.pop(context);
                  _showSubFilterOptions(context, 'Blood Group', selectedBloodGroupFilters, (newSelection) {
                    setState(() {
                      selectedBloodGroupFilters = newSelection;
                      _filterUsers(_searchController.text);
                    });
                  });
                },
              ),
              ListTile(
                title: const Text('Clear Filters'),
                trailing: const Icon(Icons.clear),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    selectedGroupFilters.clear();
                    selectedProfessionFilters.clear();
                    selectedBloodGroupFilters.clear();
                    _filterUsers(_searchController.text); // Reset the filter
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }


  //String? filterCategory; // Declare filterCategory at the class level

  void _showSubFilterOptions(BuildContext context, String filterCategory, List<String> selectedFilters, Function(List<String>) onSelectedFiltersChanged) {
    List<Map<String, String>> subOptions = [];

    if (filterCategory == 'Group') {
      subOptions = group;
    } else if (filterCategory == 'Profession') {
      subOptions = professions;
    } else if (filterCategory == 'Blood Group') {
      subOptions = bloodGroup;
    }

    // Temporary list for selected filters, initialized with the current selections
    List<String> tempSelectedFilters = List.from(selectedFilters);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder( // Use StatefulBuilder to manage state within the dialog
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text('Select $filterCategory'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: subOptions.map((Map<String, String> option) {
                    String optionCode = option['CAT_CODE'] ?? option['PROF_CODE'] ?? option['BLOOD_CODE']!;
                    bool isSelected = tempSelectedFilters.contains(optionCode);

                    return CheckboxListTile(
                      title: Text(option['CAT_DESC'] ?? option['PROF_DESC'] ?? option['BLOOD_DESC'] ?? ''),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelectedFilters.add(optionCode);
                          } else {
                            tempSelectedFilters.remove(optionCode);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    // When OK is clicked, pass the selected filters back to the parent
                    onSelectedFiltersChanged(tempSelectedFilters);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

}
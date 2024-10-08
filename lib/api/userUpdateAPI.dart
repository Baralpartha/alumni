import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://103.106.118.10/ndc90_api/userupdate.php'; // API Endpoint

  Future<bool> updateUserData(Map<String, dynamic> updatedUserData) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedUserData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          return true;
        } else {
          print('Error: ${responseData['message']}');
          return false;
        }
      } else {
        print('Server Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}

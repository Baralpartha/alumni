import 'package:http/http.dart' as http;
import 'dart:convert';

// Function to fetch division data
Future<List<Map<String, String>>> fetchDivisions() async {
  final response = await http.get(Uri.parse('http://103.106.118.10/ndc90_api/div.php'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == 1) {
      // Return the division data as a list of maps
      return List<Map<String, String>>.from(jsonResponse['data']);
    } else {
      throw Exception('Failed to load division data');
    }
  } else {
    throw Exception('Failed to connect to the server');
  }
}

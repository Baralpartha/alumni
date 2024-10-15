import 'dart:convert';
import 'package:http/http.dart' as http;

List<Map<String, String>> divisions = [];

Future<void> fetchDivisions() async {
  final response = await http.get(Uri.parse('http://103.106.118.10/ndc90_api/div.php'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 1) {
      // Map the division data to the format you need
      divisions = List<Map<String, String>>.from(data['data'].map((division) {
        return {
          'DIV_CODE': division['DIV_CODE'],
          'DIV_DESC': division['DIV_DESC'],
        };
      }));
    }
  } else {
    throw Exception('Failed to load divisions');
  }
}

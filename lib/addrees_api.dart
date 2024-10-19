import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressApiService {
  // Base URLs for the API endpoints
  static const String divisionUrl = "http://103.106.118.10/ndc90_api/div.php";
  static const String districtUrl = "http://103.106.118.10/ndc90_api/district.php?div_code=";
  static const String thanaUrl = "http://103.106.118.10/ndc90_api/thana.php?dist_code=";

  // Method to fetch Divisions
  Future<List<dynamic>> fetchDivisions() async {
    final response = await http.get(Uri.parse(divisionUrl));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load divisions');
    }
  }

  // Method to fetch Districts by Division Code
  Future<List<dynamic>> fetchDistricts(String divCode) async {
    final response = await http.get(Uri.parse(districtUrl + divCode));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load districts');
    }
  }

  // Method to fetch Thanas by District Code
  Future<List<dynamic>> fetchThanas(String distCode) async {
    final response = await http.get(Uri.parse(thanaUrl + distCode));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load thanas');
    }
  }

  // Method to get Division Description by Code
  Future<String?> getDivisionDescription(String divCode) async {
    var divisions = await fetchDivisions();
    for (var division in divisions) {
      if (division['DIV_CODE'] == divCode) {
        return division['DIV_DESC'];
      }
    }
    return null;
  }

  // Method to get District Description by Code
  Future<String?> getDistrictDescription(String divCode, String distCode) async {
    var districts = await fetchDistricts(divCode);
    for (var district in districts) {
      if (district['DIST_CODE'] == distCode) {
        return district['DIST_DESC'];
      }
    }
    return null;
  }

  // Method to get Thana Description by Code
  Future<String?> getThanaDescription(String distCode, String thanaCode) async {
    var thanas = await fetchThanas(distCode);
    for (var thana in thanas) {
      if (thana['THANA_CODE'] == thanaCode) {
        return thana['THANA_DESC'];
      }
    }
    return null;
  }
}

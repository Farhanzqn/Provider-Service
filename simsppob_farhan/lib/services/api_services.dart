import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://take-home-test-api.nutech-integrasi.com';
  Future<Map<String, dynamic>?> fetchUserProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/profile'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load profile');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchBalance() async {
    final response = await http.get(Uri.parse('$baseUrl/balance'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load balance');
      return null;
    }
  }
}

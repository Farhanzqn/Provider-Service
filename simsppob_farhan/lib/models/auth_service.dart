import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';

class AuthService with ChangeNotifier {
  String? _token;
  double _topUpAmount = 0.0;
  double get topUpAmount => _topUpAmount;

  String? get token => _token;
  List<Map<String, dynamic>> transactions = [];
  int offset = 0;
  final int limit = 5;
  bool isLoading = false;
  bool hasMoreData = true;

  // Register new user
  Future<void> register(
      String email, String firstName, String lastName, String password) async {
    final url = Uri.parse(
        'https://take-home-test-api.nutech-integrasi.com/registration');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      // Successfully registered
      print(responseData['message']);
    } else {
      throw Exception(responseData['message'] ?? 'Registration failed');
    }
  }

  // Login user and store token
  Future<void> login(String email, String password) async {
    final url =
        Uri.parse('https://take-home-test-api.nutech-integrasi.com/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _token = responseData['data']['token'];
      notifyListeners();
    } else {
      throw Exception(responseData['message'] ?? 'Login failed');
    }
  }

  // Top-up amount (between 10,000 and 1,000,000)
  void updateTopUpAmount(double amount) {
    if (amount >= 10000 && amount <= 1000000) {
      _topUpAmount = amount;
      notifyListeners();
    } else {
      throw Exception("Top-up amount must be between 10,000 and 1,000,000.");
    }
  }

  // Perform top-up action
  Future<void> topUp(String amount) async {
    if (_token == null) throw Exception('User is not logged in');
    if (_topUpAmount < 10000 || _topUpAmount > 1000000) {
      throw Exception('Amount must be between 10,000 and 1,000,000');
    }

    final url =
        Uri.parse('https://take-home-test-api.nutech-integrasi.com/topup');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'amount': amount,
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      // Handle success (perhaps show a message or update UI)
      print(responseData['message']);
    } else {
      throw Exception(responseData['message'] ?? 'Top-up failed');
    }
  }

  // Get user profile
  Future<Map<String, dynamic>> getProfile() async {
    if (_token == null) throw Exception('User is not logged in');
    final response = await http.get(
      Uri.parse('https://take-home-test-api.nutech-integrasi.com/profile'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Update user profile
  Future<void> updateProfile(String firstName, String lastName) async {
    if (_token == null) throw Exception('User is not logged in');
    final response = await http.put(
      Uri.parse(
          'https://take-home-test-api.nutech-integrasi.com/profile/update'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          jsonDecode(response.body)['message'] ?? 'Failed to update profile');
    }
  }

  // Upload profile image
  Future<void> uploadProfileImage(File imageFile) async {
    if (_token == null) throw Exception('User is not logged in');
    final mimeType =
        lookupMimeType(imageFile.path) ?? 'image/jpeg'; // default to jpeg
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(
          'https://take-home-test-api.nutech-integrasi.com/profile/image'),
    )
      ..headers['Authorization'] = 'Bearer $_token'
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload profile image');
    }
  }

  Future<void> fetchTransactions() async {
    if (isLoading || !hasMoreData) return; // prevent duplicate requests

    isLoading = true;
    notifyListeners();

    // Gantilah dengan URL API yang sesuai
    final url = Uri.parse(
        'https://take-home-test-api.nutech-integrasi.com/transaction/history?offset=$offset&limit=$limit');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer YOUR_TOKEN', // Ganti dengan token yang valid
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newTransactions =
          List<Map<String, dynamic>>.from(data['data']['records']);

      if (newTransactions.isEmpty) {
        hasMoreData = false;
      }

      transactions.addAll(newTransactions);
      offset += limit;
    } else {
      // Handle error (misalnya token expired)
      print('Failed to fetch transactions: ${response.body}');
    }

    isLoading = false;
    notifyListeners();
  }

  // Logout and clear token
  void logout() {
    _token = null;
    notifyListeners();
  }
}

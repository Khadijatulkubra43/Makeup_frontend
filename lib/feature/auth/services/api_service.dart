import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// const String baseUrl = 'https://zohaibanwer.pythonanywhere.com/api/';
const String baseUrl = 'http://192.168.100.130:8000/api/'; // FOR DEBUGGING

class ApiService {
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/login/'),
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['key'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return true;
    }
    return false;
  }

  static Future<Map<String, dynamic>> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("No authentication token found.");
    }

    dynamic response = await http.get(
      Uri.parse('${baseUrl}username/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get User Details: ${response.reasonPhrase}");
    }
  }

  static Future<bool> register(String username, String password1,
      String password2, String email, String firstName, String lastName) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/registration/'),
      headers: {
        'Content-Type':
            'application/json', // Set Content-Type to application/json
      },
      body: json.encode({
        'username': username,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password1': password1,
        'password2': password2,
      }),
    );
    return response.statusCode == 204;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      await http.post(
        Uri.parse('${baseUrl}auth/logout/'),
        headers: {'Authorization': 'Token $token'},
      );
      await prefs.remove('token');
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return false;
    }

    final response = await http.get(
      Uri.parse('${baseUrl}checkLogin/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 204;
  }
}
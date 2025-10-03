import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/user_model.dart';


class AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl = "http://10.0.2.2:5000/api/auth";

  AuthRemoteDataSource(this.client);

  Future<UserModel> signup(
      String email, String password, String confirmPassword, String role) async {
    final response = await client.post(
      Uri.parse("$baseUrl/signup"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'role': role,
      }),
    );
    print(response.body);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    } else {
      throw data['error'] ?? 'Failed to signup';
    }
  }

  Future<UserModel> login(String email, String password,String role ) async {
    final response = await client.post(
      Uri.parse("$baseUrl/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {

      return UserModel.fromJson(data);
    } else {
      throw data['error'] ?? 'Failed to login';
    }
  }

  Future<void> logout(String token) async {
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pashu_dhan/Core/Constants/app_constants.dart';

import '../../models/user_model.dart';
import '../local/local_datasource.dart';


class AuthRemoteDataSource {
  final http.Client client;
  final baseUrl=AppConstants().baseUrl;

  AuthRemoteDataSource(this.client);

  Future<UserModel> signup(
      String email, String password, String confirmPassword, String role,double lat,double long) async {
    final response = await client.post(
      Uri.parse("$baseUrl/signup"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'role': role,
        'latitude':lat,
        'longitude':long
      }),
    );
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

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    final data = jsonDecode(response.body);
    print("login data $data");
    if (response.statusCode == 200) {
      print(UserModel.fromJson(data));
      return UserModel.fromJson(data);
    } else {
      throw data['error'] ?? 'Failed to login';
    }
  }

  Future<UserModel> updateProfile({required String? name, String? role, String? phoneNumber}) async {
    final localDatasource = LocalDatasource();
    final token = await localDatasource.getAccessToken();

    final response = await client.post(
      Uri.parse('$baseUrl/update-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'role': role, 'phoneNumber': phoneNumber}),
    );
    print(response.body);

    final data = jsonDecode(response.body);
    print("UpdateProfile response: $data");
    if (response.statusCode == 200) {
      return UserModel.fromJson(data['user']);
    } else {
      throw data['error'] ?? 'Failed to update profile';
    }
  }

  Future<UserModel> fetchProfile() async {
    final localDatasource = LocalDatasource();
    final token = await localDatasource.getAccessToken();

    if (token == null) throw "No token found. Please login again.";

    final response = await client.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Fetch profile response: ${response.body}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(data['user']);
    } else {
      throw data['error'] ?? 'Failed to fetch profile';
    }
  }


  Future<void> logout(String token) async {

  }
}

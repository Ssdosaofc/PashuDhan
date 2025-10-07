import 'dart:ffi';

import '../../Domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String email,
    required String role,
    this.name,
    String? token,
    String? phoneNumber,
    double? lat,
    double? long
  }) : super(email: email, role: role, token: token, name: name, phoneNumber: phoneNumber,lat: lat,long: long);

  final String? name;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      role: json['role'] ?? 'unknown',
      token: json['token'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      lat: json['lat'],
      long: json['long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'token': token,
      'name': name,
      'phoneNumber': phoneNumber,
      'lat': lat,
      'long': long,
    };
  }
}

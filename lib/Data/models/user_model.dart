import '../../Domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String email,
    required String role,
    this.name,
    String? token,
    String? phoneNumber,
  }) : super(email: email, role: role, token: token, name: name, phoneNumber: phoneNumber,);

  final String? name;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      role: json['role'] ?? 'unknown',
      token: json['token'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'token': token,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}

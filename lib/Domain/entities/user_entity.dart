import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email;
  final String role;
  final String? token;
  final String? name;
  final String? phoneNumber;

  const UserEntity({required this.email, required this.role, this.token, this.name,this.phoneNumber,});

  @override
  List<Object?> get props => [email, role, token,name];
}

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email;
  final String role;
  final String? token;

  const UserEntity({required this.email, required this.role, this.token});

  @override
  List<Object?> get props => [email, role, token];
}

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email;
  final String role;
  final String? token;
  final String? name;
  final String? phoneNumber;
  final double? lat;
  final double? long;

  const UserEntity({required this.email, required this.role, this.token, this.name,this.phoneNumber,this.lat,this.long});

  @override
  List<Object?> get props => [email, role, token,name,phoneNumber,lat,long];
}

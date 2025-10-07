import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupEvent extends AuthEvent {
  final String email, password, confirmPassword, role;
  final double lat;
  final double long;
  SignupEvent(this.email, this.password, this.confirmPassword, this.role,this.lat,this.long);

  @override
  List<Object?> get props => [email, password, confirmPassword, role,lat,long];
}

class LoginEvent extends AuthEvent {
  final String email, password, role;
  LoginEvent(this.email, this.password, this.role);

  @override
  List<Object?> get props => [email, password,role];
}



class LogoutEvent extends AuthEvent {
  final String token;
  LogoutEvent(this.token);

  @override
  List<Object?> get props => [token];
}
class ProfileFetched extends AuthEvent {
  final String role;
  final String name;
  final String phoneNumber;

  ProfileFetched({required this.role, required this.name, required this.phoneNumber});
}



class UpdateProfileEvent extends AuthEvent {
  final String? name;
  final String? role;
  final String? phoneNumber;

  UpdateProfileEvent({required this.name, this.role, this.phoneNumber});
}

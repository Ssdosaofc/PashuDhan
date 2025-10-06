import 'package:equatable/equatable.dart';
import 'package:pashu_dhan/Domain/entities/user_entity.dart';

import '../../../Data/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String? token;
  final String? role;
  final String? name;
  final String? phoneNumber;
  final String? message;
  AuthSuccess({this.token, this.role, this.message, this.name, this.phoneNumber});
}
class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class UpdateProfileLoading extends AuthState {}

class UpdateProfileSuccess extends AuthState {
  final UserEntity user;
  UpdateProfileSuccess(this.user);
}

class UpdateProfileFailure extends AuthState {
  final String error;
  UpdateProfileFailure(this.error);
}

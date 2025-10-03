import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signup(String email, String password, String confirmPassword, String role);
  Future<UserEntity> login(String email, String password,String role);
  Future<void> logout(String token);
}

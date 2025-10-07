import '../../Data/models/user_model.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signup(String email, String password, String confirmPassword, String role, double lat,double long);
  Future<UserEntity> login(String email, String password,String role);
  Future<void> logout(String token);
  Future<UserEntity> updateProfile({required String? name, String? role, String? phoneNumber});
}

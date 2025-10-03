import '../../Domain/entities/user_entity.dart';
import '../../Domain/repository/auth_repository.dart';
import '../datasource/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> signup(
      String email, String password, String confirmPassword, String role) async {
    final userModel =
    await remoteDataSource.signup(email, password, confirmPassword, role);
    return userModel;
  }

  @override
  Future<UserEntity> login(String email, String password,String role) async {
    final userModel = await remoteDataSource.login(email, password, role);
    return userModel;
  }

  @override
  Future<void> logout(String token) async {
    await remoteDataSource.logout(token);
  }
}

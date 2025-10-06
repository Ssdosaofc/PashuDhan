import '../../Domain/entities/user_entity.dart';
import '../../Domain/repository/auth_repository.dart';
import '../datasource/local/local_datasource.dart';
import '../datasource/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalDatasource localDatasource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDatasource);

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

    if(userModel.token != null){
      await localDatasource.writeAccessToken(userModel.token!);
    }
    return userModel;
  }

  @override
  Future<UserEntity> updateProfile({required String name, String? role, String? phoneNumber}) async {
    final response = await remoteDataSource.updateProfile(name: name, role: role, phoneNumber: phoneNumber);

    return UserEntity(
      name: response.name,
      phoneNumber: response.phoneNumber,
      email: response.email,
      role: response.role,
      token: response.token,
    );
  }


  @override
  Future<void> logout(String token) async {
    await localDatasource.clearAccessToken();
  }


}

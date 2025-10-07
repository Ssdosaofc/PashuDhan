import '../../entities/user_entity.dart';
import '../../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password, String role) {
    return repository.login(email, password,role);
  }
}

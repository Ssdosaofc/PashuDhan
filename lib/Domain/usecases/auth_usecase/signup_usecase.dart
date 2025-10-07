import '../../entities/user_entity.dart';
import '../../repository/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<UserEntity> call(String email, String password, String confirmPassword, String role,double lat,double long) {
    return repository.signup(email, password, confirmPassword, role,lat,long);
  }
}

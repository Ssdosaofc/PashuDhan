
import '../../repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call(String token) {
    return repository.logout(token);
  }
}

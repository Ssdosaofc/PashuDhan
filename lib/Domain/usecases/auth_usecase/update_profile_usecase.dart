

import '../../entities/user_entity.dart';
import '../../repository/auth_repository.dart';


class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserEntity> updateProfile({required String name, String? role, String? phoneNumber}) async {
    final updatedUser = await repository.updateProfile(name: name, role: role, phoneNumber: phoneNumber);
    return updatedUser;
  }


}

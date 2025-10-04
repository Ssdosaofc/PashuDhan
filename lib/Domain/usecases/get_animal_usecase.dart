import '../entities/animal_entity.dart';
import '../repository/animal_repository.dart';

class GetAnimalsUseCase {
  final AnimalRepository repository;

  GetAnimalsUseCase(this.repository);

  Future<Map<String, dynamic>> call() {
    return repository.getAnimals();
  }
}

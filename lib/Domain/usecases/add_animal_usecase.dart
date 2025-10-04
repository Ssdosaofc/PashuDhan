import '../entities/animal_entity.dart';
import '../repository/animal_repository.dart';

class AddAnimalUseCase {
  final AnimalRepository repository;

  AddAnimalUseCase(this.repository);

  Future<AnimalEntity> call(String name, String type) {
    return repository.addAnimal(name, type);
  }
}

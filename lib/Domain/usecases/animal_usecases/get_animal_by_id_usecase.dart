
import '../../repository/animal_repository.dart';

class GetAnimalIdsByNameUseCase {
  final AnimalRepository repository;

  GetAnimalIdsByNameUseCase(this.repository);

  Future<List<String>> call(String name) {
    return repository.getAnimalIdsByName(name);
  }
}

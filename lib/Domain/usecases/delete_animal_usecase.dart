import '../repository/animal_repository.dart';

class DeleteAnimalUseCase {
  final AnimalRepository repository;

  DeleteAnimalUseCase(this.repository);

  Future<void> call(String animalId) async {
    return await repository.deleteAnimal(animalId);
  }
}

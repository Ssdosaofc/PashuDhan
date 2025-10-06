import '../entities/animal_entity.dart';

abstract class AnimalRepository {
  Future<AnimalEntity> addAnimal(String name, String type);
  Future<Map<String, dynamic>> getAnimals();
  Future<void> deleteAnimal(String animalId);
}

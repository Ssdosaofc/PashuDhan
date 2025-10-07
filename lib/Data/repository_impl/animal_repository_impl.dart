import '../../Domain/entities/animal_entity.dart';
import '../../Domain/repository/animal_repository.dart';
import '../datasource/remote/animal_remote_datasource.dart';
import '../models/animal_model.dart';

class AnimalRepositoryImpl implements AnimalRepository {
  final AnimalRemoteDataSource remoteDS;

  AnimalRepositoryImpl(this.remoteDS);

  @override
  Future<Map<String, dynamic>> getAnimals() async {
    final data = await remoteDS.getAnimals();
    final List<AnimalModel> models = data['animals'];
    final int totalCount = data['totalCount'] ?? models.length;
    final int monthlyCount = data['monthlyCount'] ?? 0;

    final List<AnimalEntity> entities =
    models.map((model) => AnimalEntity(id: model.id, name: model.name, type: model.type))
        .toList();

    return {
      'animals': entities,
      'totalCount': totalCount,
      'monthlyCount': monthlyCount,
    };
  }


  @override
  Future<AnimalEntity> addAnimal(String name, String type) async {
    final animalModel = await remoteDS.addAnimal(name, type);

    return AnimalEntity(
      id: animalModel.id,
      name: animalModel.name,
      type: animalModel.type,
    );
  }

  @override
  Future<void> deleteAnimal(String animalId) async {
    await remoteDS.deleteAnimal(animalId);
  }


    @override
    Future<List<String>> getAnimalIdsByName(String name) {
      return remoteDS.fetchAnimalIdsByName(name);
    }

}



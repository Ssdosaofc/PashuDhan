

import '../../entities/treatment_entity.dart';
import '../../repository/treatment_repository.dart';

class GetTreatmentsByAnimalUseCase {
  final TreatmentRepository repository;

  GetTreatmentsByAnimalUseCase(this.repository);

  Future<List<TreatmentEntity>> call(String animal) async {
    return await repository.getTreatmentsByAnimal(animal);
  }
}
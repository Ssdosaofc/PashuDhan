

import '../../entities/treatment_entity.dart';
import '../../repository/treatment_repository.dart';

class AddTreatmentUseCase {
  final TreatmentRepository repository;

  AddTreatmentUseCase(this.repository);

  Future<TreatmentEntity> call(TreatmentEntity treatment) async {
    return await repository.addTreatment(treatment);
  }
}
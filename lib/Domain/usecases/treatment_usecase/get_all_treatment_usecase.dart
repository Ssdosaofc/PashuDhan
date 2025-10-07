
import '../../entities/treatment_entity.dart';
import '../../repository/treatment_repository.dart';

class GetAllTreatmentsUseCase {
  final TreatmentRepository repository;

  GetAllTreatmentsUseCase(this.repository);

  Future<List<TreatmentEntity>> call() async {
    return await repository.getAllTreatments();
  }
}
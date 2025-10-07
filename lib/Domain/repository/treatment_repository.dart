
import '../entities/treatment_entity.dart';

abstract class TreatmentRepository {
  Future<TreatmentEntity> addTreatment(TreatmentEntity treatment);
  Future<List<TreatmentEntity>> getTreatmentsByAnimal(String animal);
  Future<void> deleteTreatment(String treatmentId);
  Future<List<TreatmentEntity>> getAllTreatments();
}

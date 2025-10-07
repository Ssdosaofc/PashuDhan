import 'package:pashu_dhan/Domain/entities/treatment_entity.dart';
import 'package:pashu_dhan/Domain/repository/treatment_repository.dart';
import 'package:pashu_dhan/Data/datasource/remote/treatment_remote_datasource.dart';
import 'package:pashu_dhan/Data/models/treatment_model.dart';

class TreatmentRepositoryImpl implements TreatmentRepository {
  final TreatmentRemoteDatasource remoteTreatments;

  TreatmentRepositoryImpl(this.remoteTreatments);

  @override
  Future<TreatmentEntity> addTreatment(TreatmentEntity treatment) async {
    final model = TreatmentModel(
      treatmentId: treatment.treatmentId,
      animal: treatment.animal,
      disease: treatment.disease,
      prescription: treatment.prescription,
      dosage: treatment.dosage,
      when: treatment.when,
      duration: treatment.duration,
    );

    final result = await remoteTreatments.addTreatment(model);
    return result;
  }

  @override
  Future<List<TreatmentEntity>> getTreatmentsByAnimal(String animal) async {
    final result = await remoteTreatments.getTreatmentsByAnimal(animal);
    return result;
  }

  @override
  Future<void> deleteTreatment(String treatmentId) {
    throw UnimplementedError();
  }

  @override
  Future<List<TreatmentEntity>> getAllTreatments() async {
    final result = await remoteTreatments.getAllTreatments();
    return result;
  }

}

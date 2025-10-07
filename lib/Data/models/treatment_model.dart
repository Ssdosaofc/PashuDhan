import 'package:pashu_dhan/Domain/entities/treatment_entity.dart';

class TreatmentModel extends TreatmentEntity {
  TreatmentModel({
    required super.treatmentId,
    required super.animal,
    required super.disease,
    required super.prescription,
    required super.dosage,
    required super.when,
    required super.duration,
  });

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
      treatmentId: json['treatmentId'] ?? '',
      animal: json['animal'] ?? '',
      disease: json['disease'] ?? '',
      prescription: json['prescription'] ?? '',
      dosage: json['dosage'] ?? '',
      when: json['when'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'treatmentId': treatmentId,
    'animal': animal,
    'disease': disease,
    'prescription': prescription,
    'dosage': dosage,
    'when': when,
    'duration': duration,
  };
}

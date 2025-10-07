
class TreatmentEntity {
  final String treatmentId;
  final String animal;
  final String disease;
  final String prescription;
  final String dosage;
  final String when;
  final String duration;

  TreatmentEntity({
    required this.treatmentId,
    required this.animal,
    required this.disease,
    required this.prescription,
    required this.dosage,
    required this.when,
    required this.duration,
  });
}

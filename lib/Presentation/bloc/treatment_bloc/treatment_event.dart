import 'package:equatable/equatable.dart';
import '../../../../Domain/entities/treatment_entity.dart';

abstract class TreatmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTreatmentsByAnimal extends TreatmentEvent {
  final String animal;

  FetchTreatmentsByAnimal(this.animal);

  @override
  List<Object?> get props => [animal];
}


class AddTreatmentEvent extends TreatmentEvent {
  final TreatmentEntity treatment;

  AddTreatmentEvent(this.treatment);

  @override
  List<Object?> get props => [treatment];
}

class FetchAllTreatments extends TreatmentEvent {}



class DeleteTreatmentEvent extends TreatmentEvent {
  final String treatmentId;

  DeleteTreatmentEvent(this.treatmentId);

  @override
  List<Object?> get props => [treatmentId];
}

import 'package:equatable/equatable.dart';
import '../../../../Domain/entities/treatment_entity.dart';

abstract class TreatmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TreatmentInitial extends TreatmentState {}

class TreatmentLoading extends TreatmentState {}

class TreatmentLoaded extends TreatmentState {
  final List<TreatmentEntity> treatments;

  TreatmentLoaded(this.treatments);

  @override
  List<Object?> get props => [treatments];
}

class TreatmentError extends TreatmentState {
  final String message;

  TreatmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class TreatmentAdded extends TreatmentState {
  final TreatmentEntity treatment;

  TreatmentAdded(this.treatment);

  @override
  List<Object?> get props => [treatment];
}

class TreatmentDeleted extends TreatmentState {
  final String treatmentId;

  TreatmentDeleted(this.treatmentId);

  @override
  List<Object?> get props => [treatmentId];
}

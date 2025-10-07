import 'package:equatable/equatable.dart';
import '../../../Domain/entities/animal_entity.dart';

abstract class AnimalEvent extends Equatable {
  const AnimalEvent();

  @override
  List<Object?> get props => [];
}

class GetAnimalsEvent extends AnimalEvent {

  const GetAnimalsEvent();

  @override
  List<Object?> get props => [];
}

class AddAnimalEvent extends AnimalEvent {
  final String name;
  final String type;

  const AddAnimalEvent({required this.name, required this.type});

  @override
  List<Object?> get props => [name, type];
}

class DeleteAnimalEvent extends AnimalEvent {
  final String animalId;

  DeleteAnimalEvent({required this.animalId});
}

class FetchAnimalIdsByNameEvent extends AnimalEvent {
  final String name;
  FetchAnimalIdsByNameEvent(this.name);
  @override
  List<Object?> get props => [name];
}



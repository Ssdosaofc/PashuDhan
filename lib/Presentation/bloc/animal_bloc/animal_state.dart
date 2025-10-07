import 'package:equatable/equatable.dart';
import '../../../Domain/entities/animal_entity.dart';
enum AnimalAction { add, delete, none }


abstract class AnimalState extends Equatable {
  const AnimalState();

  @override
  List<Object?> get props => [];
}

class AnimalInitial extends AnimalState {}

class AnimalLoading extends AnimalState {
  final List<AnimalEntity> animals;
  AnimalLoading({this.animals = const []});
}

class AnimalDeletedSuccess extends AnimalState {}

class AnimalSuccess extends AnimalState {
  final List<AnimalEntity> animals;
  final int? totalCount;
  final int? monthlyCount;
  final AnimalEntity? animal;
  final AnimalAction lastAction;

  const AnimalSuccess( {this.animals = const [], required this.totalCount,required this.monthlyCount,this.animal, this.lastAction = AnimalAction.none});

  @override
  List<Object?> get props => [animals, animal,totalCount];
}

class AnimalFailure extends AnimalState {
  final String error;

  const AnimalFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AnimalIdsInitial extends AnimalState {}

class AnimalIdsLoading extends AnimalState {}

class AnimalIdsLoaded extends AnimalState {
  final List<String> ids;
  AnimalIdsLoaded(this.ids);

  @override
  List<Object?> get props => [ids];
}

class AnimalIdsError extends AnimalState {
  final String message;
  AnimalIdsError(this.message);

  @override
  List<Object?> get props => [message];
}

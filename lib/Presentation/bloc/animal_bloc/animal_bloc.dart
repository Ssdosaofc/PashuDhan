import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Domain/entities/animal_entity.dart';
import '../../../Domain/usecases/add_animal_usecase.dart';
import '../../../Domain/usecases/get_animal_usecase.dart';
import '../../../Domain/usecases/delete_animal_usecase.dart';
import 'animal_event.dart';
import 'animal_state.dart';

class AnimalBloc extends Bloc<AnimalEvent, AnimalState> {
  final GetAnimalsUseCase getAnimalsUseCase;
  final AddAnimalUseCase addAnimalUseCase;
  final DeleteAnimalUseCase deleteAnimalUseCase;

  AnimalBloc({
    required this.getAnimalsUseCase,
    required this.addAnimalUseCase,
    required this.deleteAnimalUseCase,
  }) : super(AnimalInitial()) {
    on<GetAnimalsEvent>(_onGetAnimals);
    on<AddAnimalEvent>(_onAddAnimal);
    on<DeleteAnimalEvent>(_onDeleteAnimal);
  }

  Future<void> _onGetAnimals(GetAnimalsEvent event, Emitter<AnimalState> emit) async {
    final previousAnimals = state is AnimalSuccess ? (state as AnimalSuccess).animals : <AnimalEntity>[];
    emit(AnimalLoading(animals: previousAnimals));
    try {
      final result = await getAnimalsUseCase();
      final animals = result['animals'] as List<AnimalEntity>;
      final totalCount = result['totalCount'] as int;
      emit(AnimalSuccess(animals: animals, totalCount: totalCount));
    } catch (e) {
      emit(AnimalFailure(e.toString()));
    }
  }

  Future<void> _onAddAnimal(AddAnimalEvent event, Emitter<AnimalState> emit) async {
    emit(AnimalLoading(animals: state is AnimalSuccess ? (state as AnimalSuccess).animals : []));
    try {
      final addedAnimal = await addAnimalUseCase(event.name, event.type);

      final result = await getAnimalsUseCase();
      final animals = result['animals'] as List<AnimalEntity>;
      final totalCount = result['totalCount'] as int;

      emit(AnimalSuccess(
        animals: animals,
        totalCount: totalCount,
        animal: addedAnimal,
        lastAction: AnimalAction.add,
      ));
    } catch (e, st) {
      emit(AnimalFailure(e.toString()));
    }
  }

  Future<void> _onDeleteAnimal(DeleteAnimalEvent event, Emitter<AnimalState> emit) async {
    try {
      await deleteAnimalUseCase(event.animalId);

      final currentAnimals = state is AnimalSuccess
          ? List<AnimalEntity>.from((state as AnimalSuccess).animals)
          : <AnimalEntity>[];

      final updatedAnimals = currentAnimals.where((a) => a.id != event.animalId).toList();
      final totalCount = updatedAnimals.length;

      emit(AnimalSuccess(
        animals: updatedAnimals,
        totalCount: totalCount,
        lastAction: AnimalAction.delete,
      ));
    } catch (e) {
      emit(AnimalFailure(e.toString()));
    }
  }
}

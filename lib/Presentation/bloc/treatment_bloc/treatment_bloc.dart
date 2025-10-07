import 'package:flutter_bloc/flutter_bloc.dart';
import 'treatment_event.dart';
import 'treatment_state.dart';
import '../../../../Domain/usecases/treatment_usecase/get_treatment_usecase.dart';
import '../../../../Domain/usecases/treatment_usecase/add_treatment_usecase.dart';
import '../../../../Domain/usecases/treatment_usecase/get_all_treatment_usecase.dart';

class TreatmentBloc extends Bloc<TreatmentEvent, TreatmentState> {
  final GetTreatmentsByAnimalUseCase getTreatmentUseCase;
  final AddTreatmentUseCase addTreatmentUseCase;
  final GetAllTreatmentsUseCase getAllTreatmentUseCase;


  TreatmentBloc({
    required this.getTreatmentUseCase,
    required this.addTreatmentUseCase,
    required this.getAllTreatmentUseCase,
  }) : super(TreatmentInitial()) {

    on<FetchTreatmentsByAnimal>((event, emit) async {
      emit(TreatmentLoading());
      try {
        final treatments = await getTreatmentUseCase(event.animal);
        emit(TreatmentLoaded(treatments));
      } catch (e) {
        emit(TreatmentError(e.toString()));
      }
    });
    on<FetchAllTreatments>((event, emit) async {
      emit(TreatmentLoading());
      final treatments = await getAllTreatmentUseCase();
      emit(TreatmentLoaded(treatments));
    });


    on<AddTreatmentEvent>((event, emit) async {
      emit(TreatmentLoading());
      try {
        final treatment = await addTreatmentUseCase(event.treatment);
        emit(TreatmentAdded(treatment));

        // Fetch updated treatments after adding
        final treatments = await getTreatmentUseCase(treatment.animal);
        emit(TreatmentLoaded(treatments));
      } catch (e) {
        emit(TreatmentError(e.toString()));
      }
    });

    on<DeleteTreatmentEvent>((event, emit) async {
      // You will need a DeleteTreatmentUseCase if you follow clean architecture strictly
      emit(TreatmentLoading());
      try {
        // Example:
        // await deleteTreatmentUseCase(event.treatmentId);
        emit(TreatmentDeleted(event.treatmentId));
      } catch (e) {
        emit(TreatmentError(e.toString()));
      }
    });
  }
}

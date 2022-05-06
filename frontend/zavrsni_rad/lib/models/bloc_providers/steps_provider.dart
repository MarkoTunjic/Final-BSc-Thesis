import 'package:bloc/bloc.dart';
import 'package:zavrsni_rad/models/recipe_step.dart';

abstract class StepEvent {}

class AddStep extends StepEvent {
  final RecipeStep step;
  AddStep({required this.step}) : super();
}

class RemoveStep extends StepEvent {
  final int index;
  RemoveStep({required this.index}) : super();
}

class EditStep extends StepEvent {
  final int index;
  final RecipeStep step;
  EditStep({required this.index, required this.step}) : super();
}

class BlocSteps extends Bloc<StepEvent, List<RecipeStep>> {
  BlocSteps() : super([RecipeStep(step: "")]) {
    on<AddStep>((event, emit) {
      state.add(event.step);
      emit([...state]);
    });
    on<RemoveStep>((event, emit) {
      state.removeAt(event.index);
      emit([...state]);
    });
    on<EditStep>((event, emit) {
      state[event.index] = event.step;
      emit([...state]);
    });
  }
}

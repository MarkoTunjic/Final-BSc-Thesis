import 'package:bloc/bloc.dart';

abstract class StepEvent {}

class AddStep extends StepEvent {
  final String step;
  AddStep({required this.step}) : super();
}

class RemoveStep extends StepEvent {
  final int index;
  RemoveStep({required this.index}) : super();
}

class EditStep extends StepEvent {
  final int index;
  final String step;
  EditStep({required this.index, required this.step}) : super();
}

class BlocSteps extends Bloc<StepEvent, List<String>> {
  BlocSteps() : super([""]) {
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

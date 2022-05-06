import 'package:bloc/bloc.dart';
import 'package:zavrsni_rad/models/ingredient.dart';

abstract class IngredientEvent {}

class AddIngredient extends IngredientEvent {
  final Ingredient ingredient;
  AddIngredient({required this.ingredient}) : super();
}

class RemoveIngredient extends IngredientEvent {
  final int index;
  RemoveIngredient({required this.index}) : super();
}

class EditIngredient extends IngredientEvent {
  final int index;
  final Ingredient ingredient;
  EditIngredient({required this.index, required this.ingredient}) : super();
}

class BlocIngredients extends Bloc<IngredientEvent, List<Ingredient>> {
  BlocIngredients() : super([Ingredient()]) {
    on<AddIngredient>((event, emit) {
      state.add(event.ingredient);
      emit([...state]);
    });
    on<RemoveIngredient>((event, emit) {
      state.removeAt(event.index);
      emit([...state]);
    });
    on<EditIngredient>((event, emit) {
      state[event.index] = event.ingredient;
      emit([...state]);
    });
  }
}

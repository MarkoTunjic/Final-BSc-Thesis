import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavrsni_rad/models/bloc_providers/ingredients_provider.dart';
import 'package:zavrsni_rad/models/ingredient.dart';
import 'package:zavrsni_rad/widgets/add_remove_widget.dart';
import 'package:zavrsni_rad/widgets/new_ingredient_widget.dart';

class IngredientsWidget extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientsWidget({Key? key, required this.ingredients})
      : super(key: key);
  List<Widget> getInputs(List<Ingredient> ingredients) {
    List<Widget> inputs = [];
    int i = 0;
    for (Ingredient ingredient in ingredients) {
      inputs.add(NewIngredientWidget(
        index: i,
        ingredient: ingredient,
        key: ValueKey(ingredient.hashCode + i),
      ));
      i++;
    }
    return inputs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...getInputs(ingredients),
        AddRemoveWidget(
          string: "Ingredient",
          add: (() {
            BlocProvider.of<BlocIngredients>(context).add(
              AddIngredient(
                ingredient: Ingredient(),
              ),
            );
          }),
          remove: (() {
            BlocProvider.of<BlocIngredients>(context).add(
              RemoveIngredient(
                index: ingredients.length - 1,
              ),
            );
          }),
        ),
      ],
    );
  }
}

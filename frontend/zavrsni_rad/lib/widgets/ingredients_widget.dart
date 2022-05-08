import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../models/constants/constants.dart' as constants;

class IngredientsWidget extends StatelessWidget {
  final List<Ingredient> ingredients;
  const IngredientsWidget({Key? key, required this.ingredients})
      : super(key: key);
  List<Widget> _getWidgets() {
    List<Widget> widgets = [];
    for (Ingredient ingredient in ingredients) {
      widgets.add(_IngredientWidget(ingredient: ingredient));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _getWidgets(),
    );
  }
}

class _IngredientWidget extends StatelessWidget {
  final Ingredient ingredient;
  const _IngredientWidget({Key? key, required this.ingredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          color: constants.green,
          size: 15,
        ),
        Text(
          " " +
              ingredient.quantity.toString() +
              " " +
              ingredient.measure! +
              " " +
              ingredient.ingredientName!,
          style: const TextStyle(
            fontSize: 20,
            color: constants.darkBlue,
          ),
        ),
      ],
    );
  }
}

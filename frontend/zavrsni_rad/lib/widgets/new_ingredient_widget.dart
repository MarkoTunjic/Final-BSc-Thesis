import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavrsni_rad/models/bloc_providers/ingredients_provider.dart';
import 'package:zavrsni_rad/screens/new_recipe_screen.dart';
import 'package:zavrsni_rad/widgets/input_field_widget.dart';

import '../models/ingredient.dart';

class NewIngredientWidget extends StatelessWidget {
  final int _index;
  final Ingredient _ingredient;
  const NewIngredientWidget({
    Key? key,
    required int index,
    required Ingredient ingredient,
  })  : _index = index,
        _ingredient = ingredient,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 20;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          InputFieldWidget(
            hintText: "Ingredient",
            onSaved: (newValue) {
              _ingredient.ingredientName = newValue;
              BlocProvider.of<BlocIngredients>(context)
                  .add(EditIngredient(index: _index, ingredient: _ingredient));
            },
            obscure: false,
            type: TextInputType.text,
            width: availableWidth * 4 / 10 - 20,
            initialValue: _ingredient.ingredientName,
          ),
          InputFieldWidget(
            hintText: "Quantity",
            onSaved: (newValue) {
              _ingredient.quantity = (newValue == null || newValue.isEmpty)
                  ? null
                  : int.parse(newValue);
              BlocProvider.of<BlocIngredients>(context)
                  .add(EditIngredient(index: _index, ingredient: _ingredient));
            },
            obscure: false,
            type: TextInputType.number,
            width: availableWidth * 3 / 10 - 15,
            initialValue: _ingredient.quantity == null
                ? null
                : _ingredient.quantity!.toString(),
          ),
          InputFieldWidget(
            hintText: "Measure",
            onSaved: (newValue) {
              _ingredient.measure = newValue;
              BlocProvider.of<BlocIngredients>(context)
                  .add(EditIngredient(index: _index, ingredient: _ingredient));
            },
            obscure: false,
            type: TextInputType.text,
            width: availableWidth * 3 / 10 - 15,
            initialValue: _ingredient.measure,
          ),
          InkWell(
            child: const Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
            onTap: () {
              NewRecipeScreen.formKey.currentState?.save();
              BlocProvider.of<BlocIngredients>(context)
                  .add(RemoveIngredient(index: _index));
            },
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

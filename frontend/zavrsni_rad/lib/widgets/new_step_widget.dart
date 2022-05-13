import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavrsni_rad/models/bloc_providers/steps_provider.dart';
import 'package:zavrsni_rad/widgets/multiline_input_field_widget.dart';
import '../models/constants/constants.dart' as constants;
import '../utilities/validation.dart' as validators;
import '../models/recipe_step.dart';
import '../screens/new_recipe_screen.dart';

class NewStepWidget extends StatelessWidget {
  final RecipeStep step;
  final int index;

  const NewStepWidget({Key? key, required this.step, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 20;
    return Padding(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: constants.grey,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            radius: availableWidth / 24,
          ),
          MultilineInputFieldWidget(
            hintText: "New step\n\n",
            onSaved: (newValue) {
              step.step = newValue ?? "";
              BlocProvider.of<BlocSteps>(context)
                  .add(EditStep(index: index, step: step));
            },
            initialValue: step.step.isEmpty ? null : step.step,
            width: availableWidth * 4 / 5,
            validator: (input) {
              String? validationResult;
              validationResult = validators.validateNotEmpty(input);
              if (validationResult != null) return validationResult;
              validationResult = validators.validateLength(input, 500);
              if (validationResult != null) return validationResult;
              return null;
            },
          ),
          InkWell(
            child: const Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
            onTap: () {
              NewRecipeScreen.formKey.currentState?.save();
              BlocProvider.of<BlocSteps>(context).add(RemoveStep(index: index));
            },
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      padding: const EdgeInsets.only(bottom: 10),
    );
  }
}

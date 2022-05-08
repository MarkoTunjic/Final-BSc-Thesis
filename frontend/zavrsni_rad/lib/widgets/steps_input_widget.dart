import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavrsni_rad/models/bloc_providers/steps_provider.dart';
import 'package:zavrsni_rad/models/recipe_step.dart';
import 'package:zavrsni_rad/widgets/new_step_widget.dart';

import 'add_remove_widget.dart';

class StepsWidget extends StatelessWidget {
  final List<RecipeStep> steps;
  const StepsWidget({Key? key, required this.steps}) : super(key: key);

  List<Widget> getWidgets() {
    List<Widget> widgets = [];
    int i = 0;
    for (RecipeStep step in steps) {
      widgets.add(
        NewStepWidget(
          step: step,
          index: i,
          key: ValueKey(step.hashCode + i),
        ),
      );
      i++;
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...getWidgets(),
        AddRemoveWidget(
          string: "Step",
          add: (() {
            BlocProvider.of<BlocSteps>(context).add(
              AddStep(
                step: RecipeStep(step: ""),
              ),
            );
          }),
          remove: (() {
            BlocProvider.of<BlocSteps>(context).add(
              RemoveStep(
                index: steps.length - 1,
              ),
            );
          }),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zavrsni_rad/models/recipe_step.dart';

import '../models/constants/constants.dart' as constants;

class StepsWidget extends StatelessWidget {
  final List<RecipeStep> steps;
  const StepsWidget({Key? key, required this.steps}) : super(key: key);
  List<Widget> _getWidgets() {
    steps.sort(((a, b) => a.orderNumber!.compareTo(b.orderNumber!)));
    List<Widget> widgets = [];
    for (RecipeStep step in steps) {
      widgets.add(_StepWidget(step: step));
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

class _StepWidget extends StatelessWidget {
  final RecipeStep step;
  const _StepWidget({Key? key, required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundColor: constants.grey,
            child: Text(
              (step.orderNumber! + 1).toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            radius: 10,
          ),
        ),
        Flexible(
          child: Text(
            step.step,
            style: const TextStyle(
              fontSize: 20,
              color: constants.darkBlue,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

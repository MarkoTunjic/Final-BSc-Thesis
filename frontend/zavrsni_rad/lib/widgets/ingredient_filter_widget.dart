import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;

class IngredientFilterWidget extends StatelessWidget {
  final String ingredientName;
  final void Function() onDelete;
  const IngredientFilterWidget(
      {Key? key, required this.ingredientName, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height / 10,
        decoration: BoxDecoration(
          border: Border.all(color: constants.darkBlue),
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                ingredientName,
                style: const TextStyle(color: constants.darkBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

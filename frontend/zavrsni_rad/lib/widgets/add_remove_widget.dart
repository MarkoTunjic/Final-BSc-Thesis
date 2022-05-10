import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;
import '../screens/new_recipe_screen.dart';

class AddRemoveWidget extends StatelessWidget {
  final String string;
  final void Function() add;
  final void Function() remove;

  const AddRemoveWidget(
      {Key? key, required this.string, required this.add, required this.remove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            NewRecipeScreen.formKey.currentState?.save();
            add();
          },
          child: Container(
            child: Center(
              child: Text(
                "+ " + string,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            width: (MediaQuery.of(context).size.width - 20) / 2 - 10,
            height: MediaQuery.of(context).size.height / 17,
            decoration: BoxDecoration(
              border: Border.all(color: constants.grey),
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            margin: const EdgeInsets.only(top: 10),
          ),
        ),
        InkWell(
          onTap: () {
            NewRecipeScreen.formKey.currentState?.save();
            remove();
          },
          child: Container(
            child: Center(
              child: Text(
                "- " + string,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            width: (MediaQuery.of(context).size.width - 20) / 2 - 10,
            height: MediaQuery.of(context).size.height / 17,
            decoration: BoxDecoration(
              border: Border.all(color: constants.grey),
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            margin: const EdgeInsets.only(top: 10),
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}

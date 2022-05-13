import 'package:flutter/material.dart';
import 'package:zavrsni_rad/screens/new_recipe_screen.dart';
import '../models/constants/constants.dart' as constants;

class MultilineInputFieldWidget extends StatelessWidget {
  final String _hintText;
  final void Function(String?)? _onSaved;
  final String? initialValue;
  final double width;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  const MultilineInputFieldWidget({
    Key? key,
    required String hintText,
    void Function(String?)? onSaved,
    required this.width,
    this.initialValue,
    this.onChanged,
    Icon? icon,
    this.validator,
  })  : _hintText = hintText,
        _onSaved = onSaved,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        onSaved: _onSaved,
        autocorrect: false,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        enableSuggestions: false,
        initialValue: initialValue,
        autofocus: false,
        onChanged: onChanged,
        onTap: () => NewRecipeScreen.formKey.currentState?.save(),
        validator: validator,
        decoration: InputDecoration(
          hintText: _hintText,
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: constants.errorRed,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: constants.inputBorder,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
        ),
      ),
      width: width,
    );
  }
}

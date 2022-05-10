import 'package:flutter/material.dart';
import 'package:zavrsni_rad/screens/new_recipe_screen.dart';
import '../models/constants/constants.dart' as constants;

class InputFieldWidget extends StatelessWidget {
  final String _hintText;
  final void Function(String?)? _onSaved;
  final bool _obscure;
  final Icon? _icon;
  final String? _initialValue;
  final double _width;
  final TextInputType _type;
  final void Function(String)? _onChanged;
  final void Function()? onEditingCompleted;
  const InputFieldWidget({
    Key? key,
    required String hintText,
    void Function(String?)? onSaved,
    required bool obscure,
    required double width,
    required TextInputType type,
    Icon? icon,
    String? initialValue,
    void Function(String)? onChanged,
    this.onEditingCompleted,
  })  : _hintText = hintText,
        _onSaved = onSaved,
        _obscure = obscure,
        _icon = icon,
        _initialValue = initialValue,
        _width = width,
        _type = type,
        _onChanged = onChanged,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        onSaved: _onSaved,
        autocorrect: false,
        obscureText: _obscure,
        enableSuggestions: false,
        initialValue: _initialValue,
        keyboardType: _type,
        onChanged: _onChanged,
        onEditingComplete: onEditingCompleted,
        decoration: InputDecoration(
          hintText: _hintText,
          hintStyle: const TextStyle(fontSize: 15),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            borderSide: BorderSide(
              color: constants.errorRed,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          prefixIcon: _icon,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            borderSide: BorderSide(
              color: constants.inputBorder,
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
        ),
      ),
      width: _width,
    );
  }
}

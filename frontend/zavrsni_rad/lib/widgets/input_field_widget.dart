import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;

class InputFieldWidget extends StatelessWidget {
  final String _hintText;
  final void Function(String?) _onSaved;
  final bool _obscure;
  final Icon _icon;
  const InputFieldWidget(
      {Key? key,
      required String hintText,
      required void Function(String?) onSaved,
      required bool obscure,
      required Icon icon})
      : _hintText = hintText,
        _onSaved = onSaved,
        _obscure = obscure,
        _icon = icon,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        onSaved: (newValue) => _onSaved(newValue),
        autocorrect: false,
        obscureText: _obscure,
        enableSuggestions: false,
        decoration: InputDecoration(
          hintText: _hintText,
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
      width: MediaQuery.of(context).size.width - 20,
    );
  }
}

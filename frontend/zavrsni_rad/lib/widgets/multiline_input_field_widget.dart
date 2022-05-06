import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;

class MultilineInputFieldWidget extends StatelessWidget {
  final String _hintText;
  final void Function(String?) _onSaved;
  final String? initialValue;
  final double width;
  const MultilineInputFieldWidget(
      {Key? key,
      required String hintText,
      required void Function(String?) onSaved,
      required this.width,
      this.initialValue,
      Icon? icon})
      : _hintText = hintText,
        _onSaved = onSaved,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        onSaved: (newValue) => _onSaved(newValue),
        autocorrect: false,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        enableSuggestions: false,
        initialValue: initialValue,
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

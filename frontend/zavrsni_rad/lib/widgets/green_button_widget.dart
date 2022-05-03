import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;

class GreenButton extends StatelessWidget {
  final void Function() _onPressed;
  final String _text;

  const GreenButton({
    Key? key,
    required void Function() onPressed,
    required String text,
  })  : _onPressed = onPressed,
        _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () => _onPressed(),
      child: Container(
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
        width: width / 3 * 2,
        padding: const EdgeInsets.all(15),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          constants.green,
        ),
      ),
    );
  }
}

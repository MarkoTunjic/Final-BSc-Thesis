import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../models/constants/constants.dart' as constants;

class PicturePickerWidget extends StatelessWidget {
  final Future<void> Function() _onTap;
  final Widget text;
  final double iconSize;
  final Radius radius;

  const PicturePickerWidget({
    Key? key,
    required this.text,
    required Future<void> Function() onTap,
    required this.iconSize,
    required this.radius,
  })  : _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      child: SizedBox(
        child: InkWell(
          onTap: _onTap,
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.image,
                  color: constants.grey,
                  size: iconSize,
                ),
                text,
              ],
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width - 20,
      ),
      radius: radius,
      color: constants.grey,
      borderType: BorderType.RRect,
    );
  }
}

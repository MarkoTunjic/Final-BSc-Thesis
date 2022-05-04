import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/constants/constants.dart' as constants;

class PicturePickerWidget extends StatelessWidget {
  final Future<void> Function() _onTap;

  const PicturePickerWidget({
    Key? key,
    required Future<void> Function() onTap,
  })  : _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      child: SizedBox(
        child: InkWell(
          onTap: () => _onTap(),
          child: Column(
            children: const [
              Icon(
                Icons.image,
                color: constants.grey,
                size: 30,
              ),
              Text(
                "Choose profile picture (optional)",
                style: TextStyle(fontSize: 15, color: constants.grey),
              ),
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width - 20,
      ),
      radius: const Radius.circular(100),
      color: constants.grey,
      borderType: BorderType.RRect,
    );
  }
}

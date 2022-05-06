import 'dart:io';

import 'package:flutter/material.dart';

class BlocProfilePictureWidget extends StatelessWidget {
  final File? _image;
  const BlocProfilePictureWidget({Key? key, required File? image})
      : _image = image,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CircleAvatar(
        backgroundImage: FileImage(_image!),
        radius: MediaQuery.of(context).size.width / 10,
      ),
    );
  }
}

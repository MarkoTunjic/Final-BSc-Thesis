import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zavrsni_rad/models/bloc_providers/cover_picture_provider.dart';
import 'package:zavrsni_rad/widgets/picture_picker_widget.dart';
import '../models/constants/constants.dart' as constants;

class BlocCoverPictureWidget extends StatelessWidget {
  final File? _image;
  const BlocCoverPictureWidget({Key? key, required File? image})
      : _image = image,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    if (_image == null) {
      return PicturePickerWidget(
        text: Column(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Add Cover Photo",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Text(
                "(Up To 12MB)",
                style: TextStyle(color: constants.grey, fontSize: 10),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        onTap: () async {
          final XFile? video =
              await picker.pickImage(source: ImageSource.gallery);
          if (video != null) {
            File file = File(video.path);
            BlocProvider.of<BlocCoverPicture>(context)
                .add(SetImage(image: file));
            return;
          }
        },
        iconSize: MediaQuery.of(context).size.width / 10,
        radius: const Radius.circular(20),
      );
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ClipRRect(
            child: Image.file(
              _image!,
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.width * 2 / 3,
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
        ),
        Positioned(
          child: InkWell(
            child: const Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
            onTap: () {
              BlocProvider.of<BlocCoverPicture>(context).add(RemoveImage());
            },
          ),
          right: 0,
        ),
      ],
    );
  }
}

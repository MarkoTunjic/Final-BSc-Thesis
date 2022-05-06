import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavrsni_rad/models/bloc_providers/recipe_images_provider.dart';

class ImagesWidget extends StatelessWidget {
  final List<File> images;

  const ImagesWidget({Key? key, required this.images}) : super(key: key);

  List<Widget> _getWidgets() {
    List<Widget> widgets = [];
    int i = 0;
    for (File file in images) {
      widgets.add(_ImageWidget(image: file, index: i));
      i++;
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? Container()
        : Container(
            child: ListView(
              children: [..._getWidgets()],
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
            ),
            height: MediaQuery.of(context).size.width / 4,
            margin: const EdgeInsets.all(10),
          );
  }
}

class _ImageWidget extends StatelessWidget {
  final File image;
  final int index;

  const _ImageWidget({Key? key, required this.image, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 20;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            child: Image.file(
              image,
              width: availableWidth / 4,
              height: availableWidth / 4,
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        Positioned(
          child: InkWell(
            child: const Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
            onTap: () {
              BlocProvider.of<BlocImages>(context)
                  .add(RemoveImage(index: index));
            },
          ),
          right: 0,
        ),
      ],
    );
  }
}

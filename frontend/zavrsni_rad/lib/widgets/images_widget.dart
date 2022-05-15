import 'package:flutter/material.dart';

class ImagesWidget extends StatelessWidget {
  final List<String> images;
  const ImagesWidget({Key? key, required this.images}) : super(key: key);

  List<Widget> _getWidgets() {
    List<Widget> widgets = [];
    for (String image in images) {
      widgets.add(_ImageWidget(image: image));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 2,
        child: PageView(
          controller: PageController(initialPage: 0),
          scrollDirection: Axis.horizontal,
          children: _getWidgets(),
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final String image;
  const _ImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.network(
        image,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CircularImageWithWhiteBorder extends StatelessWidget {
  final String _imageLocation;
  final double _radius;

  const CircularImageWithWhiteBorder(
      {Key? key, required String imageLocation, required double radius})
      : _imageLocation = imageLocation,
        _radius = radius,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: _radius,
        child: CircleAvatar(
          radius: _radius - 10,
          backgroundImage: AssetImage(_imageLocation),
        ),
      ),
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey)]),
    );
  }
}

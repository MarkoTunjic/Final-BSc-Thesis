import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:zavrsni_rad/models/bloc_providers/video_provider.dart';

class BlocVideoWidget extends StatefulWidget {
  final File video;
  final int index;

  const BlocVideoWidget({Key? key, required this.video, required this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BlocVideoState();
  }
}

class _BlocVideoState extends State<BlocVideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    double availableWidth = MediaQuery.of(context).size.width - 20;
    return _controller.value.isInitialized
        ? Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  child: ClipRRect(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  width: availableWidth / 4,
                  height: availableWidth / 4,
                ),
              ),
              Positioned(
                child: InkWell(
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  onTap: () {
                    BlocProvider.of<BlocVideo>(context).add(
                      RemoveVideo(index: widget.index),
                    );
                  },
                ),
                right: 0,
              ),
            ],
          )
        : Container();
  }
}

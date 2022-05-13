import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:zavrsni_rad/models/bloc_providers/video_provider.dart';
import 'package:zavrsni_rad/widgets/picture_picker_widget.dart';
import '../models/constants/constants.dart' as constants;

class BlocVideoWidget extends StatefulWidget {
  final File? video;

  const BlocVideoWidget({Key? key, this.video}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BlocVideoState();
  }
}

class _BlocVideoState extends State<BlocVideoWidget> {
  late VideoPlayerController _controller;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.video != null) {
      _controller = VideoPlayerController.file(widget.video!)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.video == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: PicturePickerWidget(
          text: Column(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  "Select video",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "(Up To 50MB)",
                  style: TextStyle(color: constants.grey, fontSize: 10),
                ),
              ),
            ],
          ),
          onTap: () async {
            final XFile? video =
                await _picker.pickVideo(source: ImageSource.gallery);
            if (video != null) {
              File file = File(video.path);
              _controller = VideoPlayerController.file(file)
                ..initialize().then((_) => setState(() {}));
              BlocProvider.of<BlocVideo>(context).add(SetVideo(video: file));
              return;
            }
          },
          iconSize: MediaQuery.of(context).size.width / 10,
          radius: const Radius.circular(20),
        ),
      );
    } else {
      return _controller.value.isInitialized
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
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
                      BlocProvider.of<BlocVideo>(context).add(RemoveVideo());
                    },
                  ),
                  right: 0,
                ),
              ],
            )
          : Container();
    }
  }
}

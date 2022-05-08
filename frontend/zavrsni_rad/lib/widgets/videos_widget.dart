import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideosWidget extends StatelessWidget {
  final List<String> videos;
  const VideosWidget({Key? key, required this.videos}) : super(key: key);

  List<Widget> _getWidgets() {
    List<Widget> widgets = [];
    for (String video in videos) {
      widgets.add(_VideoWidget(video: video));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      child: PageView(
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.horizontal,
        children: _getWidgets(),
      ),
    );
  }
}

class _VideoWidget extends StatefulWidget {
  final String video;
  const _VideoWidget({Key? key, required this.video}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoWidgetState();
  }
}

class _VideoWidgetState extends State<_VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        Center(
          child: InkWell(
            child: _controller.value.isPlaying
                ? Icon(Icons.pause,
                    color: const Color.fromARGB(182, 158, 158, 158),
                    size: MediaQuery.of(context).size.width / 5)
                : Icon(
                    Icons.play_arrow_rounded,
                    color: const Color.fromARGB(182, 158, 158, 158),
                    size: MediaQuery.of(context).size.width / 5,
                  ),
            onTap: () {
              setState(() {
                if (!_controller.value.isPlaying) {
                  _controller.play();
                  return;
                }
                _controller.pause();
              });
            },
          ),
        ),
      ],
      alignment: Alignment.center,
    );
  }
}

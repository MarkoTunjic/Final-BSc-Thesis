import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zavrsni_rad/widgets/picture_picker_widget.dart';
import '../models/bloc_providers/video_provider.dart';
import '../models/constants/constants.dart' as constants;
import 'bloc_video_widget.dart';

class BlocVideosWidget extends StatefulWidget {
  final List<File> videos;
  const BlocVideosWidget({Key? key, required this.videos}) : super(key: key);

  @override
  _BlocVideosWidgetState createState() => _BlocVideosWidgetState();
}

class _BlocVideosWidgetState extends State<BlocVideosWidget> {
  final ImagePicker _picker = ImagePicker();

  List<Widget> _getWidgets() {
    List<Widget> widgets = [];
    int i = 0;
    for (File video in widget.videos) {
      widgets.add(BlocVideoWidget(
        key: ValueKey(video.path + i.toString()),
        index: i,
        video: video,
      ));
      i++;
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
                    "(Up To 20MB)",
                    style: TextStyle(color: constants.grey, fontSize: 10),
                  ),
                ),
              ],
            ),
            onTap: () async {
              final XFile? video =
                  await _picker.pickVideo(source: ImageSource.gallery);
              if (video != null) {
                video.length().then(
                  (value) {
                    if (value < 20000000) {
                      File file = File(video.path);
                      BlocProvider.of<BlocVideo>(context)
                          .add(AddVideo(video: file));
                    } else {
                      Fluttertoast.showToast(
                        msg: "Video too big", // message
                        toastLength: Toast.LENGTH_SHORT, // length
                        gravity: ToastGravity.BOTTOM, // location// duration
                      );
                    }
                  },
                );
                return;
              }
            },
            iconSize: MediaQuery.of(context).size.width / 10,
            radius: const Radius.circular(20),
          ),
        ),
        widget.videos.isEmpty
            ? Container()
            : Container(
                child: ListView(
                  children: [..._getWidgets()],
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                ),
                height: MediaQuery.of(context).size.width / 4,
                margin: const EdgeInsets.all(10),
              ),
      ],
    );
  }
}

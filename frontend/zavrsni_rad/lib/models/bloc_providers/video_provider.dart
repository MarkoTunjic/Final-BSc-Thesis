import 'dart:io';

import 'package:bloc/bloc.dart';

abstract class VideoEvent {}

class SetVideo extends VideoEvent {
  final File video;
  SetVideo({required this.video}) : super();
}

class RemoveVideo extends VideoEvent {
  RemoveVideo() : super();
}

class BlocVideo extends Bloc<VideoEvent, File?> {
  BlocVideo() : super(null) {
    on<SetVideo>((event, emit) {
      emit(event.video);
    });
    on<RemoveVideo>((event, emit) {
      emit(null);
    });
  }
}

import 'dart:io';

import 'package:bloc/bloc.dart';

abstract class VideoEvent {}

class AddVideo extends VideoEvent {
  final File video;
  AddVideo({required this.video}) : super();
}

class RemoveVideo extends VideoEvent {
  final int index;
  RemoveVideo({required this.index}) : super();
}

class BlocVideo extends Bloc<VideoEvent, List<File>> {
  BlocVideo() : super([]) {
    on<AddVideo>((event, emit) {
      state.add(event.video);
      emit([...state]);
    });
    on<RemoveVideo>((event, emit) {
      state.removeAt(event.index);
      emit([...state]);
    });
  }
}

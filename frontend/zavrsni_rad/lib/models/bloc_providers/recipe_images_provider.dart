import 'dart:io';

import 'package:bloc/bloc.dart';

abstract class ImageEvent {}

class AddImage extends ImageEvent {
  final File image;
  AddImage({required this.image}) : super();
}

class RemoveImage extends ImageEvent {
  final int index;
  RemoveImage({required this.index}) : super();
}

class BlocImages extends Bloc<ImageEvent, List<File>> {
  BlocImages() : super([]) {
    on<AddImage>((event, emit) {
      state.add(event.image);
      emit([...state]);
    });
    on<RemoveImage>((event, emit) {
      state.removeAt(event.index);
      emit([...state]);
    });
  }
}

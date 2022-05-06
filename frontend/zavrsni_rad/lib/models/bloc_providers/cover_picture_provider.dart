import 'dart:io';

import 'package:bloc/bloc.dart';

abstract class PictureEvent {}

class SetImage extends PictureEvent {
  final File image;
  SetImage({required this.image}) : super();
}

class RemoveImage extends PictureEvent {
  RemoveImage() : super();
}

class BlocCoverPicture extends Bloc<PictureEvent, File?> {
  BlocCoverPicture() : super(null) {
    on<SetImage>((event, emit) {
      emit(event.image);
    });
    on<RemoveImage>((event, emit) {
      emit(null);
    });
  }
}

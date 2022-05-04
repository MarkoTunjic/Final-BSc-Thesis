import 'dart:io';

import 'package:bloc/bloc.dart';

abstract class ProfilePictureEvent {
  File? image;

  ProfilePictureEvent({this.image});
}

class ShowProfilePicture extends ProfilePictureEvent {
  ShowProfilePicture({required File image}) : super(image: image);
}

class HideProfilePicture extends ProfilePictureEvent {
  HideProfilePicture() : super(image: null);
}

class BlocProfilePicture extends Bloc<ProfilePictureEvent, File?> {
  BlocProfilePicture() : super(null) {
    on<ShowProfilePicture>((event, emit) => emit(event.image));
    on<HideProfilePicture>((event, emit) => emit(null));
  }
}

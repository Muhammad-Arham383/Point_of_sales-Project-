import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  final ImagePicker _imagePicker = ImagePicker();
  ImagePickerBloc() : super(ImagePickerInitialState()) {
    on<ImagePickerEvent>((event, emit) async {
      try {
        final XFile? pickedFile =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          emit(ImagePickedState(image: File(pickedFile.path)));
        }
      } catch (e) {
        Text('image cant be selected $e');
      }
    });
  }
}

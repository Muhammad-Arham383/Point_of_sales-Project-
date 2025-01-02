part of 'image_picker_bloc.dart';

@immutable
sealed class ImagePickerState {}

final class ImagePickerInitialState extends ImagePickerState {}

final class ImagePickedState extends ImagePickerState {
  ImagePickedState({required this.image});
  final File image;
}

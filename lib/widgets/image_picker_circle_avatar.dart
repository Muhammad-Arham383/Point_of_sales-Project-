import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_project/bloc/bloc/image_picker_bloc.dart';

class ImagePickerCircleAvatar extends StatelessWidget {
  final double? radius;
  const ImagePickerCircleAvatar({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImagePickerBloc(),
      child: Center(
        child: BlocBuilder<ImagePickerBloc, ImagePickerState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<ImagePickerBloc>().add(PickImageEvent());
                  },
                  child: CircleAvatar(
                    radius: radius,
                    backgroundImage: state is ImagePickedState
                        ? FileImage(state.image)
                        : null,
                    child: state is ImagePickerInitialState
                        ? const Icon(Icons.add_a_photo,
                            size: 30, color: Colors.grey)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

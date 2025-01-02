import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  const CustomTextFields(
      {super.key,
      required this.autoFocus,
      required this.textEditingController,
      required this.textInputType,
      required this.obscureText,
      required this.hintText});
  final bool autoFocus;
  final bool obscureText;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autoFocus,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      keyboardType: textInputType,
      obscureText: obscureText,
    );
  }
}

import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget {
  const CustomButtons(
      {super.key,
      required this.text,
      this.color,
      this.border,
      required this.onPressed});
  final Widget? text;
  final Color? color;
  final BoxBorder? border;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: border,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: color),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: text,
        ),
      ),
    );
  }
}

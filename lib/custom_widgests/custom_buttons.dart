import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? width;
  final double? height;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    Key? keycustombutton,
    required this.child,
    this.color,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            foregroundColor: color == null ? Colors.white : Colors.black,
            backgroundColor: color ?? Colors.blue,
            minimumSize: Size(width ?? 100, 45),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: child);
  }
}

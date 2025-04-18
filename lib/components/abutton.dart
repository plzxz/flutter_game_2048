import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double width;
  final void Function() onPressed;
  
  const MenuButton({
    super.key, 
    required this.label,
    required this.color,
    required this.textColor,
    required this.fontSize,
    required this.fontWeight,
    required this.height,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
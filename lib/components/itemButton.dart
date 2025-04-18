import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color colorButton;
  final Color colorButtonS;
  final Color colorIcon;
  final double width;
  final double? height;
  final bool isDisabled;
  final bool isHighlighted;
  final void Function()? onTap;

  const ItemButton({
    super.key,
    required this.icon,
    required this.colorButton,
    required this.colorButtonS,
    required this.colorIcon,
    required this.onTap,
    required this.height,
    required this.width,
    this.label,
    this.isDisabled = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDisabled ? colorButtonS : colorButton,
          border: Border.all(
            color: isHighlighted ? colorIcon : Colors.transparent,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(icon, color: colorIcon,),
            ),
            SizedBox(height: 10,),
            Text(label ?? "0")
          ],
        ),
      ),
    );
  }
}

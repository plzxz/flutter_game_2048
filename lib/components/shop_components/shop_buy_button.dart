import 'package:flutter/material.dart';

class ShopBuyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;

  const ShopBuyButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}

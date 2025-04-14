import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double? size;
  const MyBox ({
    super.key,
    required this.child,
    required this.color,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      width: size,
      height: size,
      padding: const EdgeInsets.all(50),
      child: child,
    );
  }
}
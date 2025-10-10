import 'package:flutter/material.dart';

class MainDivider extends StatelessWidget {
  final double height;
  final Color? color;
  const MainDivider({
    super.key,
    required this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: color ?? const Color.fromARGB(24, 97, 97, 97),
    );
  }
}

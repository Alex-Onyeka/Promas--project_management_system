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
      color: color ?? greyNeutral(),
    );
  }
}

Color greyNeutral() {
  return const Color.fromARGB(83, 141, 141, 141);
}

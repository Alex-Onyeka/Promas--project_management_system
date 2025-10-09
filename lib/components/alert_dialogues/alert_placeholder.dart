import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class AlertPlaceholder extends StatelessWidget {
  final bool? isMin;
  final Widget content;
  const AlertPlaceholder({
    super.key,
    required this.content,
    this.isMin,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: returnTheme(
        context,
        listen: false,
      ).lightGrey(),
      contentPadding: EdgeInsets.all(10),
      shape: OutlineInputBorder(
        borderRadius: mainBorderRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      content: Container(
        width: screenSize(context) >= mobileScreen
            ? 500
            : null,
        padding: EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 15,
        ),
        child: content,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class AuthContainer extends StatefulWidget {
  final double? height;
  final Widget? widget;
  const AuthContainer({
    super.key,
    this.height,
    this.widget,
  });

  @override
  State<AuthContainer> createState() =>
      _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(
        horizontal: screenSize(context) > mobileScreen
            ? 100
            : 25,
        vertical: screenSize(context) > mobileScreen
            ? 35
            : 30,
      ),
      width: screenSize(context) >= mobileScreen
          ? 650
          : null,
      decoration: BoxDecoration(
        color: returnTheme(context).containerColor(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: !returnTheme(context).isDarkMode
                ? Color.fromARGB(10, 1, 42, 75)
                : Color.fromARGB(14, 77, 175, 255),
            blurRadius: 20,
            blurStyle: BlurStyle.normal,
            spreadRadius: 20,
          ),
        ],
      ),
      child: widget.widget,
    );
  }
}

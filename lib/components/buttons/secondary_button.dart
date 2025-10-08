import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final bool? showShadow;
  const SecondaryButton({
    super.key,
    this.action,
    required this.title,
    this.showShadow,
  });

  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: showShadow != null && showShadow == false
                ? Colors.transparent
                : const Color.fromARGB(45, 33, 149, 243),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius:
                showShadow != null && showShadow == false
                ? 0
                : 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(155, 9, 95, 165),
            ),
          ),
          child: InkWell(
            onTap: action,
            child: Container(
              width: screenSize(context) > mobileScreen
                  ? 300
                  : double.infinity,
              padding: EdgeInsets.all(13.5),

              child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                title,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/constants/general_constants.dart';

class ErrorAlert extends StatelessWidget {
  final String? title;
  final String message;

  const ErrorAlert({
    super.key,
    this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(10),
      shape: OutlineInputBorder(
        borderRadius: mainBorderRadius,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      content: Container(
        // width: 10,
        // height: 300,
        padding: EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 15,
        ),
        // color: Colors.grey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            // SizedBox(height: 10),
            Text(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
              title ?? 'Error',
            ),
            Container(
              height: 2,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(
                  151,
                  255,
                  82,
                  82,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
              message,
            ),
            SizedBox(height: 10),
            SecondaryButton(
              title: 'Cancel',
              action: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

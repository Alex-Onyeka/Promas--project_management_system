import 'package:flutter/material.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/constants/general_constants.dart';

class ConfirmAlert extends StatefulWidget {
  final String buttonText;
  final Function() action;
  const ConfirmAlert({
    super.key,
    required this.buttonText,
    required this.action,
  });

  @override
  State<ConfirmAlert> createState() => _ConfirmAlertState();
}

class _ConfirmAlertState extends State<ConfirmAlert> {
  bool isLoading = false;
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
        padding: EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            HeadingSection(
              subText: 'Error Creating account',
              title: 'Proceed With Action?',
            ),
            SizedBox(height: 10),
            Column(
              spacing: 7,
              children: [
                MainButton(
                  action: () async {
                    setState(() {
                      isLoading = true;
                    });
                    widget.action();
                    await Future.delayed(
                      Duration(seconds: 2),
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  title: widget.buttonText,
                  loadingWidget: isLoading ? true : null,
                ),
                SecondaryButton(
                  title: 'Cancel',
                  action: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

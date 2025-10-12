import 'package:flutter/material.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/main.dart';

class EmptyWidgetMain extends StatelessWidget {
  final Function() action;
  final String title;
  final String buttonText;
  const EmptyWidgetMain({
    super.key,
    required this.action,
    required this.title,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        // height: double.infinity,
        child: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 30,
                color: returnTheme(
                  context,
                ).darkMediumGrey(),
                Icons.work_off_outlined,
              ),
              Text(
                style: TextStyle(
                  fontSize: 13,
                  color: returnTheme(
                    context,
                  ).darkMediumGrey(),
                ),
                title,
              ),
              SizedBox(height: 2),
              Visibility(
                visible: returnUser(
                  context,
                ).currentUser!.isAdmin,
                child: SizedBox(
                  width: 200,
                  child: MainButton(
                    action: action,
                    title: buttonText,
                  ),
                ),
              ),
              SizedBox(height: 55),
            ],
          ),
        ),
      ),
    );
  }
}

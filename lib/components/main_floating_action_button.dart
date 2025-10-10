import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class MainFloatingActionButton extends StatelessWidget {
  final Function() action;
  const MainFloatingActionButton({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: returnTheme(context).white(),
        borderRadius: mainBorderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(22, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: returnTheme(context).white(),
            borderRadius: mainBorderRadius,
          ),
          child: InkWell(
            borderRadius: mainBorderRadius,
            onTap: () {
              action();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    color: returnTheme(
                      context,
                    ).tertiaryColor(),
                    size: 18,
                    Icons.add,
                  ),
                  Text(
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: returnTheme(
                        context,
                      ).darkGrey(),
                    ),
                    'Create Project',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

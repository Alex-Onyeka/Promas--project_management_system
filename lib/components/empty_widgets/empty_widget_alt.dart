import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class EmptyWidgetAlt extends StatelessWidget {
  final Function() action;
  final String title;
  final String buttonText;
  final IconData? icon;
  final bool? showButton;
  const EmptyWidgetAlt({
    super.key,
    required this.action,
    required this.title,
    required this.buttonText,
    this.icon,
    this.showButton,
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
                size: 26,
                color: returnTheme(
                  context,
                ).darkMediumGrey(),
                icon ?? Icons.work_off_outlined,
              ),
              Text(
                style: TextStyle(
                  fontSize: 11,
                  color: returnTheme(
                    context,
                  ).darkMediumGrey(),
                ),
                title,
              ),
              SizedBox(height: 2),
              Visibility(
                visible: showButton ?? true,
                child: SizedBox(
                  width: 200,
                  child: InkWell(
                    onTap: action,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: mainBorderRadius,
                        border: Border.all(
                          color: const Color.fromARGB(
                            59,
                            66,
                            66,
                            66,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          style: TextStyle(
                            fontSize: 11,
                            color: returnTheme(
                              context,
                            ).darkMediumGrey(),
                          ),
                          buttonText,
                        ),
                      ),
                    ),
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

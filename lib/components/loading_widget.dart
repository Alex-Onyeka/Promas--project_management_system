import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class LoadingWidget extends StatelessWidget {
  final Function() action;
  const LoadingWidget({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(47, 0, 0, 0),
      child: Center(
        child: Container(
          height: 380,
          width: 380,
          decoration: BoxDecoration(
            color: returnTheme(
              context,
              listen: false,
            ).lightGrey(),
            borderRadius: mainBorderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: action,
                      icon: Icon(
                        color: returnTheme(
                          context,
                          listen: false,
                        ).darkMediumGrey(),
                        size: 20,
                        Icons.clear,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: CircularProgressIndicator(
                  color: returnTheme(
                    context,
                    listen: false,
                  ).darkGrey(),
                ),
              ),
              Opacity(
                opacity: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        color: returnTheme(
                          context,
                          listen: false,
                        ).darkMediumGrey(),
                        size: 20,
                        Icons.clear,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

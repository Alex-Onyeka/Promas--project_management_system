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
            color: returnTheme().lightGrey(),
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
                        color: returnTheme()
                            .darkMediumGrey(),
                        size: 20,
                        Icons.clear,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: returnLoader(text: 'Loading...'),
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
                        color: returnTheme()
                            .darkMediumGrey(),
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

Widget returnLoader({String? text}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircularProgressIndicator.adaptive(),
      Visibility(
        visible: text != null,
        child: Column(
          children: [
            SizedBox(height: 15),
            Text(
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              text ?? 'Loading...',
            ),
          ],
        ),
      ),
    ],
  );
}

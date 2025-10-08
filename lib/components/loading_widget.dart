import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';

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
            color: Colors.white,
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
                        color: Colors.grey,
                        size: 20,
                        Icons.clear,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: CircularProgressIndicator.adaptive(),
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
                        color: Colors.grey,
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

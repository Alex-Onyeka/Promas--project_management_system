import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';

class MainButton extends StatefulWidget {
  final Function() action;
  final String title;
  final bool? showShadow;
  final bool? loadingWidget;
  const MainButton({
    super.key,
    required this.action,
    required this.title,
    this.showShadow,
    this.loadingWidget,
  });

  @override
  State<MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
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
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color:
                    widget.showShadow != null &&
                        widget.showShadow == false
                    ? Colors.transparent
                    : Color.fromARGB(71, 33, 149, 243),
                blurRadius: 20,
                offset: Offset(0, 10),
                spreadRadius:
                    widget.showShadow != null &&
                        widget.showShadow == false
                    ? 0
                    : 10,
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                isLoading = true;
              });
              widget.action();
            },
            child: Container(
              width: screenSize(context) > mobileScreen
                  ? 300
                  : double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                // color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color:
                        widget.showShadow != null &&
                            widget.showShadow == false
                        ? Colors.transparent
                        : Color.fromARGB(71, 33, 149, 243),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius:
                        widget.showShadow != null &&
                            widget.showShadow == false
                        ? 0
                        : 10,
                  ),
                ],
              ),
              child: Center(
                child: Stack(
                  children: [
                    Visibility(
                      visible: !isLoading,
                      // widget.loadingWidget == null ||
                      // (widget.loadingWidget != null &&
                      //     widget.loadingWidget ==
                      //         false),
                      child: Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        widget.title,
                      ),
                    ),
                    Visibility(
                      visible: isLoading,
                      // widget.loadingWidget != null &&
                      // widget.loadingWidget == true,
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

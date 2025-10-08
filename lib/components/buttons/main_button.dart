import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';

class MainButton extends StatelessWidget {
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
                    showShadow != null &&
                        showShadow == false
                    ? Colors.transparent
                    : Color.fromARGB(71, 33, 149, 243),
                blurRadius: 20,
                offset: Offset(0, 10),
                spreadRadius:
                    showShadow != null &&
                        showShadow == false
                    ? 0
                    : 10,
              ),
            ],
          ),
          child: InkWell(
            onTap: action,
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
                        showShadow != null &&
                            showShadow == false
                        ? Colors.transparent
                        : Color.fromARGB(71, 33, 149, 243),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius:
                        showShadow != null &&
                            showShadow == false
                        ? 0
                        : 10,
                  ),
                ],
              ),
              child: Center(
                child: Stack(
                  children: [
                    Visibility(
                      visible: loadingWidget == null,
                      child: Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        title,
                      ),
                    ),
                    Visibility(
                      visible: loadingWidget != null,
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

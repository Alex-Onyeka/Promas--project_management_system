import 'package:flutter/material.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class RightSideBar extends StatefulWidget {
  const RightSideBar({super.key});

  @override
  State<RightSideBar> createState() => _RightSideBarState();
}

class _RightSideBarState extends State<RightSideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize(context) > mobileScreen
          ? 170
          : null,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: const Color.fromARGB(24, 148, 148, 148),
          ),
        ),
      ),
      child: Column(
        spacing: 8,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 8,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(5),
                          color: returnTheme(
                            context,
                          ).tertiaryLight(),
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              style: TextStyle(
                                height: 0,
                                fontSize: 25,
                                color: Colors.grey.shade900,
                              ),
                              formatTime(DateTime.now()),
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Icon(
                                  size: 13,
                                  returnGreetingIcon(),
                                ),
                                Flexible(
                                  child: Text(
                                    textAlign:
                                        TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors
                                          .grey
                                          .shade900,
                                    ),
                                    returnGreetingText(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment(1.1, 1.5),
                        child: IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(
                            size: 15,
                            Icons.refresh,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      color: returnTheme(
                        context,
                      ).secondaryLight(),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          style: TextStyle(
                            height: 0,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          formatShortDate(DateTime.now()),
                        ),
                        Flexible(
                          child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                            ),
                            formatFullDate(DateTime.now()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

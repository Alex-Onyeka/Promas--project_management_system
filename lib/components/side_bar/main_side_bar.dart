import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class MainSideBar extends StatefulWidget {
  const MainSideBar({super.key});

  @override
  State<MainSideBar> createState() => _MainSideBarState();
}

class _MainSideBarState extends State<MainSideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: screenSize(context) > mobileScreen
          ? screenSize(context) * 0.18
          : null,
      decoration: BoxDecoration(
        color: returnTheme(context).lightGrey(),
      ),
    );
  }
}

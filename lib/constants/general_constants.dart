import 'package:flutter/material.dart';

double screenSize(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double mobileScreen = 450;
double tabletScreen = 950;

var mainBorderRadius = BorderRadius.only(
  bottomLeft: Radius.circular(10),
  bottomRight: Radius.circular(0),
  topLeft: Radius.circular(10),
  topRight: Radius.circular(10),
);

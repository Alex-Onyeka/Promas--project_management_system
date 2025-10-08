import 'package:flutter/material.dart';

double screenSize(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double mobileScreen = 450;

double tabletScreenSmall = 650;
double tabletScreen = 850;

double tabletScreenBig = 1150;

var mainBorderRadius = BorderRadius.only(
  bottomLeft: Radius.circular(10),
  bottomRight: Radius.circular(0),
  topLeft: Radius.circular(10),
  topRight: Radius.circular(10),
);

String appName = 'Promas';

const String mainLogo = 'assets/logo.svg';

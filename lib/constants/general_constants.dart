import 'package:flutter/material.dart';

double screenSize(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double mobileScreen = 450;

double tabletScreenSmall = 650;
double tabletScreen = 850;

double tabletScreenBig = 1150;

var mainBorderRadius = BorderRadius.only(
  bottomLeft: Radius.circular(8),
  bottomRight: Radius.circular(0),
  topLeft: Radius.circular(8),
  topRight: Radius.circular(8),
);

String appName = 'Promas';

const String mainLogo = 'assets/logo.svg';

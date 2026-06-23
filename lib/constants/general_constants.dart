import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

const String workingMan = 'assets/workingman.png';

void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Copied to clipboard")),
  );
}

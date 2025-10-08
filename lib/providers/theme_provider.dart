import 'package:flutter/material.dart';
import 'package:promas/classes/themes/dark_theme.dart';
import 'package:promas/classes/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider._internal();

  static final ThemeProvider _instance =
      ThemeProvider._internal();

  factory ThemeProvider() => _instance;
  bool isDarkMode = false;
  void switchTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  Color containerColor() {
    if (isDarkMode) {
      return DarkTheme().containerColor;
    } else {
      return LightTheme().containerColor;
    }
  }

  Color white() {
    if (isDarkMode) {
      return DarkTheme().white;
    } else {
      return LightTheme().white;
    }
  }

  Color primaryColor() {
    if (isDarkMode) {
      return DarkTheme().primaryColor;
    } else {
      return LightTheme().primaryColor;
    }
  }

  Color primaryLight() {
    if (isDarkMode) {
      return DarkTheme().primaryLight;
    } else {
      return LightTheme().primaryLight;
    }
  }

  Color secondaryColor() {
    if (isDarkMode) {
      return DarkTheme().secondaryColor;
    } else {
      return LightTheme().secondaryColor;
    }
  }

  Color secondaryLight() {
    if (isDarkMode) {
      return DarkTheme().secondaryLight;
    } else {
      return LightTheme().secondaryLight;
    }
  }

  Color tertiaryColor() {
    if (isDarkMode) {
      return DarkTheme().tertiaryColor;
    } else {
      return LightTheme().tertiaryColor;
    }
  }

  Color tertiaryLight() {
    if (isDarkMode) {
      return DarkTheme().tertiaryLight;
    } else {
      return LightTheme().tertiaryLight;
    }
  }

  Color lightGrey() {
    if (isDarkMode) {
      return DarkTheme().lightGrey;
    } else {
      return LightTheme().lightGrey;
    }
  }

  Color lightMediumGrey() {
    if (isDarkMode) {
      return DarkTheme().lightMediumGrey;
    } else {
      return LightTheme().lightMediumGrey;
    }
  }

  Color mediumGrey() {
    if (isDarkMode) {
      return DarkTheme().mediumGrey;
    } else {
      return LightTheme().mediumGrey;
    }
  }

  Color darkMediumGrey() {
    if (isDarkMode) {
      return DarkTheme().darkMediumGrey;
    } else {
      return LightTheme().darkMediumGrey;
    }
  }

  Color darkGrey() {
    if (isDarkMode) {
      return DarkTheme().darkGrey;
    } else {
      return LightTheme().darkGrey;
    }
  }
}

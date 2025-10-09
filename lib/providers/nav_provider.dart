import 'package:flutter/widgets.dart';

class NavProvider extends ChangeNotifier {
  int currentPage = 0;

  String pageName() {
    if (currentPage == 0) {
      return 'DASHBOARD';
    } else if (currentPage == 1) {
      return 'Projects';
    } else if (currentPage == 2) {
      return 'Employees';
    } else {
      return 'Requests';
    }
  }

  void navigate(int index) {
    currentPage = index;
    notifyListeners();
  }
}

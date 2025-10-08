import 'package:flutter/material.dart';
import 'package:promas/pages/auth_pages/login_page.dart';
import 'package:promas/pages/auth_pages/sign_up_page.dart';

class AuthBase extends StatefulWidget {
  const AuthBase({super.key});

  @override
  State<AuthBase> createState() => _AuthBaseState();
}

class _AuthBaseState extends State<AuthBase> {
  void switchLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPage(
        action: () {
          switchLogin();
        },
      );
    } else {
      return SignUpPage(
        action: () {
          switchLogin();
        },
      );
    }
  }
}

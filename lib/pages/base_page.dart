import 'package:flutter/material.dart';
import 'package:promas/pages/auth_pages/auth_base.dart';
import 'package:promas/pages/home.dart';
import 'package:promas/services/auth_service.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    var user = AuthService().currentUser;
    if (user != null) {
      return Home();
    } else {
      return AuthBase();
    }
  }
}

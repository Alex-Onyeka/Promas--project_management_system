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
    // return Scaffold(
    //   body: StreamBuilder(
    //     stream: AuthService().authStateChanges,
    //     builder: (context, asyncSnapshot) {
    //       if (asyncSnapshot.connectionState ==
    //           ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else if (asyncSnapshot.hasError ||
    //           asyncSnapshot.data == null) {
    //         return Center(child: Text('An Error Occured'));
    //       } else {
    //         var data = asyncSnapshot.data;
    //         if (data!.session != null) {
    //           // return Home();
    //           return Container();
    //         } else {
    //           // return AuthBase();
    //           return Container();
    //         }
    //       }
    //     },
    //   ),
    // );
  }
}

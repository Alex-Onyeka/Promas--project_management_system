import 'package:flutter/material.dart';
import 'package:promas/classes/company_class.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/pages/company/company_setup.dart';
import 'package:promas/pages/dashboard.dart/dashboard.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:promas/providers/user_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // CompanyClass? company;
  late Future<CompanyClass?> getCompanyFuture;
  Future<CompanyClass?> getCompany() async {
    print('Trying to get company');
    var company = await CompanyProvider().getMyCompany();
    print('Finished Getting company: ${company?.name}');
    return company;
  }

  late Future<UserClass?> getUserFuture;
  Future<UserClass?> getUser() async {
    return await UserProvider().getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialize();
      setState(() {});
    });
  }

  Future<void> initialize() async {
    await getUser();
    await getCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (UserProvider().currentUser == null) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            if (CompanyProvider().currentCompany == null) {
              return CompanySetup();
            } else {
              return Dashboard();
            }
          }
        },
      ),
    );
  }
}

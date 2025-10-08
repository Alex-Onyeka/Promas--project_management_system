import 'package:flutter/material.dart';
import 'package:promas/classes/request_class.dart';
import 'package:promas/pages/company/awaiting_approval_page.dart';
import 'package:promas/pages/company/set_company_page.dart';
import 'package:promas/providers/requests_provider.dart';
import 'package:promas/services/auth_service.dart';

class CompanySetup extends StatefulWidget {
  const CompanySetup({super.key});

  @override
  State<CompanySetup> createState() => _CompanySetupState();
}

class _CompanySetupState extends State<CompanySetup> {
  RequestClass? request;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      request = await RequestsProvider().getRequestByUser(
        AuthService().currentUser!.id,
      );
      setState(() {});
      print(request?.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (request == null) {
      return SetCompanyPage();
    } else {
      return AwaitingApprovalPage();
    }
  }
}

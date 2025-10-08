import 'package:flutter/material.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/containers/auth_container.dart';
import 'package:promas/components/loading_widget.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/home.dart';
import 'package:promas/providers/user_provider.dart';
import 'package:promas/services/auth_service.dart';

class AwaitingApprovalPage extends StatefulWidget {
  const AwaitingApprovalPage({super.key});

  @override
  State<AwaitingApprovalPage> createState() =>
      _AwaitingApprovalPageState();
}

class _AwaitingApprovalPageState
    extends State<AwaitingApprovalPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Transform.rotate(
                        angle: -0.18,
                        child: AuthContainer(height: 550),
                      ),
                      AuthContainer(
                        widget: Center(
                          child: SizedBox(
                            height: 500,
                            child: Column(
                              spacing: 5,
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  size: 35,
                                  color: returnTheme(
                                    context,
                                  ).primaryColor(),
                                  Icons.home_work_outlined,
                                ),
                                SizedBox(height: 2),
                                InkWell(
                                  onTap: () async {
                                    await UserProvider()
                                        .addUserToCompany(
                                          AuthService()
                                              .currentUser!
                                              .id,
                                        );
                                    if (context.mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return Home();
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    textAlign:
                                        TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: returnTheme(
                                        context,
                                      ).darkMediumGrey(),
                                    ),
                                    'Request Not Yet Approved',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  textAlign:
                                      TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: returnTheme(
                                      context,
                                    ).mediumGrey(),
                                  ),
                                  'Your Request is yet to be approved by the company... Awaiting Company to Approve your request.',
                                ),
                                SizedBox(height: 15),
                                MainButton(
                                  action: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Home();
                                        },
                                      ),
                                    );
                                  },
                                  title:
                                      'Check for Approval',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isLoading,
          child: LoadingWidget(action: () {}),
        ),
      ],
    );
  }
}

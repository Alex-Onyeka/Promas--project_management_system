import 'package:flutter/material.dart';
import 'package:promas/classes/request_class.dart';
import 'package:promas/components/alert_dialogues/confirm_alert.dart';
import 'package:promas/components/empty_widgets/empty_widget_alt.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/requests_provider.dart';
import 'package:promas/providers/user_provider.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Future<void> getAllRequests() async {
    await RequestsProvider().getRequestsByCompany();
  }

  Future<void> initFuncs() async {
    await getAllRequests();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initFuncs();
    });
  }

  @override
  Widget build(BuildContext context) {
    var requestP = returnRequest(context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (!returnRequest(
            context,
            listen: false,
          ).isLoaded) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    screenSize(context) < tabletScreenSmall
                    ? const EdgeInsets.symmetric(
                        horizontal: 0.0,
                      )
                    : const EdgeInsets.symmetric(
                        horizontal: 25.0,
                      ),
                child: Column(
                  spacing: 2,
                  children: [
                    Row(
                      children: [
                        Text(
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: returnTheme(
                              context,
                            ).darkMediumGrey(),
                          ),
                          'All Requests',
                        ),
                      ],
                    ),
                    MainDivider(height: 30),
                    SizedBox(height: 2),
                    SizedBox(
                      // height: 300,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Visibility(
                            visible:
                                requestP.requests.isEmpty,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(
                                    top: 30.0,
                                  ),
                              child: EmptyWidgetAlt(
                                icon: Icons
                                    .notifications_off_outlined,
                                showButton: false,
                                buttonText: '',
                                title:
                                    'No Requests Sent Yet',
                                action: () async {
                                  // await createProject();
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: requestP
                                .requests
                                .isNotEmpty,
                            child: Column(
                              spacing: 5,
                              children: requestP.requests
                                  .map(
                                    (req) => Container(
                                      padding:
                                          EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 18,
                                          ),
                                      decoration:
                                          BoxDecoration(
                                            color:
                                                returnTheme(
                                                  context,
                                                ).white(),
                                          ),
                                      child: Builder(
                                        builder: (context) {
                                          if (screenSize(
                                                context,
                                              ) >
                                              tabletScreenSmall) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  spacing:
                                                      5,
                                                  children: [
                                                    Icon(
                                                      size:
                                                          17,
                                                      color: returnTheme(
                                                        context,
                                                      ).tertiaryLight(),
                                                      Icons
                                                          .notifications_active_outlined,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          3,
                                                    ),
                                                    Text(
                                                      style: TextStyle(
                                                        fontSize:
                                                            11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: returnTheme(
                                                          context,
                                                        ).darkMediumGrey(),
                                                      ),
                                                      req.userName
                                                          .toUpperCase(),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            3,
                                                      ),
                                                      width:
                                                          2,
                                                      height:
                                                          18,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(
                                                          5,
                                                        ),
                                                        color:
                                                            greyNeutral(),
                                                      ),
                                                    ),
                                                    Text(
                                                      style: TextStyle(
                                                        fontSize:
                                                            11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: returnTheme(
                                                          context,
                                                        ).mediumGrey(),
                                                      ),
                                                      req.userEmail,
                                                    ),
                                                  ],
                                                ),

                                                Builder(
                                                  builder: (context) {
                                                    if (req.userId ==
                                                        null) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: mainBorderRadius,
                                                          color: const Color.fromARGB(
                                                            43,
                                                            158,
                                                            158,
                                                            158,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                            vertical: 6,
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            spacing: 5,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(
                                                                size: 16,
                                                                color: const Color.fromARGB(
                                                                  255,
                                                                  86,
                                                                  233,
                                                                  91,
                                                                ),
                                                                Icons.check,
                                                              ),
                                                              Text(
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: returnTheme(
                                                                    context,
                                                                  ).darkGrey(),
                                                                ),
                                                                'Request Accepted',
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(
                                                          top: 0.0,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          spacing: 5,
                                                          children: [
                                                            Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                onTap: () async {
                                                                  await acceptRequest(
                                                                    context,
                                                                    req,
                                                                  );
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 8.0,
                                                                    vertical: 6,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    spacing: 5,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Icon(
                                                                        size: 16,
                                                                        color: const Color.fromARGB(
                                                                          255,
                                                                          86,
                                                                          233,
                                                                          91,
                                                                        ),
                                                                        Icons.check,
                                                                      ),
                                                                      Text(
                                                                        style: TextStyle(
                                                                          fontSize: 10,
                                                                          color: const Color.fromARGB(
                                                                            255,
                                                                            62,
                                                                            158,
                                                                            66,
                                                                          ),
                                                                        ),
                                                                        'Accept Request',
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  declineRequest(
                                                                    context,
                                                                    req,
                                                                  );
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 8.0,
                                                                    vertical: 6,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    spacing: 5,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Icon(
                                                                        size: 16,
                                                                        color: const Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          92,
                                                                          92,
                                                                        ),
                                                                        Icons.delete_outlined,
                                                                      ),
                                                                      Text(
                                                                        style: TextStyle(
                                                                          fontSize: 10,
                                                                          color: const Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            92,
                                                                            92,
                                                                          ),
                                                                        ),
                                                                        'Decline Request',
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          } else {
                                            return Column(
                                              spacing: 7,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment
                                              //         .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .end,
                                              children: [
                                                Row(
                                                  spacing:
                                                      5,
                                                  children: [
                                                    Icon(
                                                      size:
                                                          17,
                                                      color: returnTheme(
                                                        context,
                                                      ).tertiaryLight(),
                                                      Icons
                                                          .notifications_active_outlined,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          2,
                                                    ),
                                                    Text(
                                                      style: TextStyle(
                                                        fontSize:
                                                            11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: returnTheme(
                                                          context,
                                                        ).darkMediumGrey(),
                                                      ),
                                                      req.userName
                                                          .toUpperCase(),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            3,
                                                      ),
                                                      width:
                                                          2,
                                                      height:
                                                          18,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(
                                                          5,
                                                        ),
                                                        color:
                                                            greyNeutral(),
                                                      ),
                                                    ),
                                                    Text(
                                                      style: TextStyle(
                                                        fontSize:
                                                            11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: returnTheme(
                                                          context,
                                                        ).mediumGrey(),
                                                      ),
                                                      req.userEmail,
                                                    ),
                                                  ],
                                                ),
                                                MainDivider(
                                                  height:
                                                      10,
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    if (req.userId ==
                                                        null) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: mainBorderRadius,
                                                          color: const Color.fromARGB(
                                                            43,
                                                            158,
                                                            158,
                                                            158,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                            vertical: 6,
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            spacing: 5,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(
                                                                size: 16,
                                                                color: const Color.fromARGB(
                                                                  255,
                                                                  86,
                                                                  233,
                                                                  91,
                                                                ),
                                                                Icons.check,
                                                              ),
                                                              Text(
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: returnTheme(
                                                                    context,
                                                                  ).darkGrey(),
                                                                ),
                                                                'Request Accepted',
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(
                                                          top: 0.0,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          spacing: 5,
                                                          children: [
                                                            Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                onTap: () async {
                                                                  await acceptRequest(
                                                                    context,
                                                                    req,
                                                                  );
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 8.0,
                                                                    vertical: 6,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    spacing: 5,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Icon(
                                                                        size: 16,
                                                                        color: const Color.fromARGB(
                                                                          255,
                                                                          86,
                                                                          233,
                                                                          91,
                                                                        ),
                                                                        Icons.check,
                                                                      ),
                                                                      Text(
                                                                        style: TextStyle(
                                                                          fontSize: 10,
                                                                          color: const Color.fromARGB(
                                                                            255,
                                                                            62,
                                                                            158,
                                                                            66,
                                                                          ),
                                                                        ),
                                                                        'Accept Request',
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  declineRequest(
                                                                    context,
                                                                    req,
                                                                  );
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 8.0,
                                                                    vertical: 6,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    spacing: 5,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Icon(
                                                                        size: 16,
                                                                        color: const Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          92,
                                                                          92,
                                                                        ),
                                                                        Icons.delete_outlined,
                                                                      ),
                                                                      Text(
                                                                        style: TextStyle(
                                                                          fontSize: 10,
                                                                          color: const Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            92,
                                                                            92,
                                                                          ),
                                                                        ),
                                                                        'Decline Request',
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> declineRequest(
    BuildContext context,
    RequestClass req,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmAlert(
          buttonText: 'Decline Request',
          action: () async {
            await RequestsProvider().deleteRequest(
              req.userId!,
            );
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          subText:
              'Are you sure you want to decline this request?',
          title: 'Decline Request?',
        );
      },
    );
  }

  Future<dynamic> acceptRequest(
    BuildContext context,
    RequestClass req,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmAlert(
          buttonText: 'Accept Request',
          action: () async {
            await UserProvider().addUserToCompany(
              req.userId!,
            );
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          subText:
              'Are you sure you want to accept this request?',
          title: 'Accept Request?',
        );
      },
    );
  }
}

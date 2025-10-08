import 'package:flutter/material.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/components/top_bar/mobile_app_bar.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: screenSize(context) > mobileScreen
          ? null
          : appBar(context: context),
      drawer: MainSideBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: screenSize(context) > tabletScreen,
            child: MainSideBar(),
          ),
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible:
                      screenSize(context) > mobileScreen,
                  child: MainTopBar(
                    globalKey: _scaffoldKey,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Column(
                                spacing: 5,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color: returnTheme(
                                            context,
                                          ).darkMediumGrey(),
                                        ),
                                        'Overview',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment
                                              .start,
                                      runSpacing: 15,
                                      spacing: 15,
                                      runAlignment:
                                          WrapAlignment
                                              .start,
                                      children: [
                                        ProjectTile(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            screenSize(context) >
                            tabletScreenBig,
                        child: RightSideBar(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectTile extends StatelessWidget {
  const ProjectTile({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: mainBorderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(10, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
        color: returnTheme(context).white(),
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: mainBorderRadius,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(10, 0, 0, 0),
                blurRadius: 10,
                spreadRadius: 10,
              ),
            ],
            color: returnTheme(context).white(),
          ),
          child: InkWell(
            borderRadius: mainBorderRadius,
            onTap: () {},
            child: Container(
              width: 300,
              height: 180,
              padding: EdgeInsets.fromLTRB(15, 20, 20, 20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.lightMediumGrey(),
                        ),
                        child: Icon(
                          size: 14,
                          color: theme.darkMediumGrey(),
                          Icons.workspace_premium_rounded,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.darkGrey(),
                          fontWeight: FontWeight.bold,
                        ),
                        'Project Name',
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 40.0,
                            ),
                            child: Text(
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.darkGrey(),
                              ),
                              'Project Description is the way of Life and Beans',
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          color: theme.lightMediumGrey(),
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                // Container(
                                //   padding: EdgeInsets.all(5),
                                //   decoration: BoxDecoration(
                                //     borderRadius:
                                //         BorderRadius.circular(3),
                                //     color: theme.darkGrey(),
                                //   ),
                                //   child: Text(
                                //     style: TextStyle(
                                //       fontSize: 8,
                                //       fontWeight: FontWeight.bold,
                                //       color: theme.white(),
                                //     ),
                                //     'Active Staffs:',
                                //   ),
                                // ),
                                Text(
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: theme
                                        .darkMediumGrey(),
                                  ),
                                  'Active Staffs:',
                                ),
                                Text(
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: theme
                                        .darkMediumGrey(),
                                  ),
                                  '2',
                                ),
                              ],
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Text(
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: theme
                                        .darkMediumGrey(),
                                  ),
                                  'Last Update:',
                                ),
                                Text(
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: theme
                                        .darkMediumGrey(),
                                  ),
                                  formatShortDateTwo(
                                    DateTime.now(),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              size: 16,
                              color: theme.darkMediumGrey(),
                              Icons
                                  .arrow_forward_ios_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RightSideBar extends StatefulWidget {
  const RightSideBar({super.key});

  @override
  State<RightSideBar> createState() => _RightSideBarState();
}

class _RightSideBarState extends State<RightSideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize(context) > mobileScreen
          ? 200
          : null,
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: returnTheme(
                    context,
                  ).tertiaryLight(),
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      style: TextStyle(
                        height: 0,
                        fontSize: 30,
                        color: Colors.grey.shade900,
                      ),
                      formatTime(DateTime.now()),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Icon(
                          size: 15,
                          returnGreetingIcon(),
                        ),
                        Flexible(
                          child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade900,
                            ),
                            returnGreetingText(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment(1, 1),
                child: IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(size: 18, Icons.refresh),
                ),
              ),
            ],
          ),
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: returnTheme(context).secondaryLight(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  style: TextStyle(
                    height: 0,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  formatShortDate(DateTime.now()),
                ),
                Flexible(
                  child: Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                    ),
                    formatFullDate(DateTime.now()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

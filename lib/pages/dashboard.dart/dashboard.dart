import 'package:flutter/material.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/theme_provider.dart';
import 'package:promas/providers/user_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: screenSize(context) > mobileScreen
          ? null
          : appBar(),
      drawer: MainSideBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MainSideBar(),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    // vertical: 20,
                  ),
                  height: 80,
                  color: returnTheme(context).white(),
                  child: Center(
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                ThemeProvider()
                                    .switchTheme();
                              },
                              child: Text(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: returnTheme(
                                    context,
                                  ).darkGrey(),
                                ),
                                'DASHBOARD',
                              ),
                            ),
                            SizedBox(width: 20),
                            SizedBox(
                              width: 350,
                              child: NormalTextfield(
                                inputController:
                                    SearchController(),
                                hintText: 'Search Project',
                                title: '',
                                isOptional: true,
                                onChanged: (value) {},
                                showTitle: false,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                Text(
                                  style: TextStyle(
                                    color: returnTheme(
                                      context,
                                    ).darkGrey(),
                                  ),
                                  UserProvider()
                                          .currentUser
                                          ?.name ??
                                      'No User Found',
                                ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: returnTheme(
                                      context,
                                    ).darkMediumGrey(),
                                  ),
                                  child: Icon(
                                    size: 18,
                                    color: returnTheme(
                                      context,
                                    ).lightGrey(),
                                    Icons.person,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                child: Stack(
                                  alignment: Alignment(
                                    1.5,
                                    -0.3,
                                  ),
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape
                                              .circle,
                                          color: returnTheme(
                                            context,
                                          ).lightMediumGrey(),
                                        ),
                                        child: Icon(
                                          size: 18,
                                          color: returnTheme(
                                            context,
                                          ).darkMediumGrey(),
                                          Icons
                                              .notifications_rounded,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        shape:
                                            BoxShape.circle,
                                        color: returnTheme(
                                          context,
                                        ).tertiaryColor(),
                                      ),
                                      child: Center(
                                        child: Text(
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                            fontSize: 9,
                                            color:
                                                returnTheme(
                                                  context,
                                                ).darkGrey(),
                                          ),
                                          returnRequest(
                                                context,
                                              )
                                              .requests
                                              .length
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(),
              ],
            ),
          ),
          RightSideBar(),
        ],
      ),
    );
  }
}

class RightSideBar extends StatelessWidget {
  const RightSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize(context) > mobileScreen
          ? screenSize(context) * 0.14
          : null,
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: 10,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: Text('DashBoard'),
    centerTitle: true,
  );
}

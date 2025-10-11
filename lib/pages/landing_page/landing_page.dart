import 'package:flutter/material.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/side_bar/right_side_bar.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/components/top_bar/mobile_app_bar.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/dashboard.dart/dashboard.dart';
import 'package:promas/pages/employees/employees.dart';
import 'package:promas/pages/projects/projects.dart';
import 'package:promas/pages/requests/requests.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  final projectSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: screenSize(context) > mobileScreen
          ? null
          : appBar(context: context),
      drawer: MainSideBar(isMain: true),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: screenSize(context) > tabletScreen,
            child: MainSideBar(isMain: true),
          ),
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible:
                      screenSize(context) > mobileScreen,
                  child: MainTopBar(
                    onChanged: (value) {
                      setState(() {});
                    },
                    searchController:
                        projectSearchController,
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
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            height: double.infinity,
                            child:
                                returnNav(
                                      context,
                                    ).currentPage ==
                                    0
                                ? Dashboard(
                                    projectSearchController:
                                        projectSearchController,
                                  )
                                : returnNav(
                                        context,
                                      ).currentPage ==
                                      1
                                ? Projects(
                                    projectSearchController:
                                        projectSearchController,
                                  )
                                : returnNav(
                                        context,
                                      ).currentPage ==
                                      2
                                ? Employees()
                                : Requests(),
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

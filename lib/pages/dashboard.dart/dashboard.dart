import 'package:flutter/material.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/user_provider.dart';

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
                Row(
                  children: [
                    Container(),
                    Visibility(
                      visible:
                          screenSize(context) >
                          tabletScreenBig,
                      child: RightSideBar(),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
          ? 400
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

AppBar appBar({required BuildContext context}) {
  return AppBar(
    titleSpacing: 0,
    iconTheme: IconThemeData(
      color: returnTheme(context).darkMediumGrey(),
    ),
    backgroundColor: returnTheme(context).white(),
    foregroundColor: Colors.transparent,
    title: Row(
      spacing: 10,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: returnTheme(context).darkMediumGrey(),
          ),
          child: Icon(
            size: 18,
            color: returnTheme(context).lightGrey(),
            Icons.person,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              style: TextStyle(
                color: returnTheme(context).darkGrey(),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              UserProvider().currentUser?.name ??
                  'No User Found..',
            ),
            Text(
              style: TextStyle(
                color: returnTheme(
                  context,
                ).darkMediumGrey(),
                fontSize: 10,
              ),
              UserProvider().currentUser!.isAdmin
                  ? 'Admin'
                  : UserProvider().currentUser!.email,
            ),
          ],
        ),
      ],
    ),
    centerTitle: true,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Stack(
              alignment: Alignment(1.5, -0.3),
              children: [
                Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: returnTheme(
                        context,
                      ).lightMediumGrey(),
                    ),
                    child: Icon(
                      size: 18,
                      color: returnTheme(
                        context,
                      ).darkMediumGrey(),
                      Icons.notifications_rounded,
                    ),
                  ),
                ),
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: returnTheme(
                      context,
                    ).tertiaryColor(),
                  ),
                  child: Center(
                    child: Text(
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                        color: returnTheme(
                          context,
                        ).darkGrey(),
                      ),
                      returnRequest(
                        context,
                      ).requests.length.toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

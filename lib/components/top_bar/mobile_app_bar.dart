import 'package:flutter/material.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/user_provider.dart';

AppBar appBar({
  required BuildContext context,
  required bool isMain,
}) {
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
            onTap: () {
              if (isMain) {
                returnNav(
                  context,
                  listen: false,
                ).navigate(3);
                screenSize(context) <= tabletScreen
                    ? Navigator.of(context).pop()
                    : {};
              } else {
                returnNav(
                  context,
                  listen: false,
                ).navigate(3);
                Navigator.of(context).pop();
                screenSize(context) <= tabletScreen
                    ? Navigator.of(context).pop()
                    : {};
              }
            },
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
                      returnRequest(context).requests
                          .where(
                            (req) => req.userId != null,
                          )
                          .length
                          .toString(),
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:promas/components/alert_dialogues/confirm_alert.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/services/auth_service.dart';

class MainSideBar extends StatefulWidget {
  final bool isMain;
  const MainSideBar({super.key, required this.isMain});

  @override
  State<MainSideBar> createState() => _MainSideBarState();
}

class _MainSideBarState extends State<MainSideBar> {
  void navigateNow(int index) {
    if (widget.isMain) {
      returnNav(context, listen: false).navigate(index);
    } else {
      returnNav(context, listen: false).navigate(index);
      Navigator.of(context).pop();
      screenSize(context) <= tabletScreen
          ? Navigator.of(context).pop()
          : {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      width: screenSize(context) > tabletScreenSmall
          ? 220
          : 270,
      decoration: BoxDecoration(
        color: returnTheme(context).lightGrey(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Row(
              spacing: 10,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(mainLogo),
                ),
                Text(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: returnTheme(
                      context,
                    ).primaryColor(),
                  ),
                  'Promas',
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 15,
                children: [
                  MenuListItem(
                    currentSelected: returnNav(
                      context,
                    ).currentPage,
                    index: 0,
                    action: () {
                      navigateNow(0);
                    },
                    title: 'DashBoard',
                    icon:
                        Icons.dashboard_customize_outlined,
                  ),
                  MenuListItem(
                    currentSelected: returnNav(
                      context,
                    ).currentPage,
                    index: 1,
                    action: () {
                      navigateNow(1);
                    },
                    title: 'Projects',
                    icon: Icons.work,
                  ),
                  MenuListItem(
                    currentSelected: returnNav(
                      context,
                    ).currentPage,
                    index: 2,
                    action: () {
                      navigateNow(2);
                    },
                    title: 'Employees',
                    icon: Icons.people_outline_outlined,
                  ),
                  MenuListItem(
                    currentSelected: returnNav(
                      context,
                    ).currentPage,
                    index: 3,
                    action: () {
                      navigateNow(3);
                    },
                    title: 'Requests',
                    icon: Icons.question_answer_outlined,
                  ),
                  MenuListItem(
                    currentSelected: returnNav(
                      context,
                    ).currentPage,
                    index: 10,
                    action: () {
                      var safeContext = context;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmAlert(
                            subText:
                                'Are you sure you want to Log out?',
                            title: 'Logout?',
                            action: () async {
                              await AuthService().signOut(
                                context: safeContext,
                              );
                            },
                            buttonText: 'Proceed',
                          );
                        },
                      );
                    },
                    title: 'Log Out',
                    icon: Icons.logout,
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Icon(
                      size: 14,
                      color: returnTheme(
                        context,
                      ).darkMediumGrey(),
                      returnTheme(context).isDarkMode
                          ? Icons.nightlight
                          : Icons.sunny,
                    ),
                    Text(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: returnTheme(
                          context,
                        ).darkMediumGrey(),
                      ),
                      returnTheme(context).isDarkMode
                          ? 'Dark Theme'
                          : 'Light Theme',
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    returnTheme(
                      context,
                      listen: false,
                    ).switchTheme();
                  },
                  child: Container(
                    height: 20,
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      color: returnTheme(
                        context,
                      ).lightMediumGrey(),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          returnTheme(context).isDarkMode
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          height: 13,
                          width: 13,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: returnTheme(
                              context,
                            ).darkMediumGrey(),
                          ),
                        ),
                      ],
                    ),
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

class MenuListItem extends StatefulWidget {
  final String title;
  final Function() action;
  final IconData icon;
  final int currentSelected;
  final int index;
  final Color? color;
  const MenuListItem({
    super.key,
    required this.title,
    required this.action,
    required this.icon,
    required this.currentSelected,
    required this.index,
    this.color,
  });

  @override
  State<MenuListItem> createState() => _MenuListItemState();
}

class _MenuListItemState extends State<MenuListItem> {
  Color? backGroundColor() {
    if (returnTheme(context).isDarkMode) {
      if (widget.currentSelected == widget.index) {
        return const Color.fromARGB(55, 255, 255, 255);
      } else {
        return const Color.fromARGB(0, 255, 255, 255);
      }
    } else {
      if (widget.currentSelected == widget.index) {
        return Colors.white;
      } else {
        return const Color.fromARGB(0, 255, 255, 255);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(color: backGroundColor()),
        child: InkWell(
          onTap: widget.action,
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Row(
                spacing: 10,
                children: [
                  Icon(
                    size:
                        widget.currentSelected ==
                            widget.index
                        ? 22
                        : 20,
                    color:
                        widget.color ??
                        returnTheme(context).darkGrey(),
                    widget.icon,
                  ),
                  Text(
                    style: TextStyle(
                      fontSize:
                          widget.currentSelected ==
                              widget.index
                          ? 11.5
                          : 10.8,
                      fontWeight: FontWeight.normal,
                      color: returnTheme(
                        context,
                      ).darkMediumGrey(),
                    ),
                    widget.title,
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

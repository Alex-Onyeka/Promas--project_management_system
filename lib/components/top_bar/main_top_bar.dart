import 'package:flutter/material.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class MainTopBar extends StatelessWidget {
  final TextEditingController searchController;
  final bool? isVisible;
  final GlobalKey<ScaffoldState> globalKey;
  final String? pageName;
  final Function(String value)? onChanged;
  final bool isMain;
  const MainTopBar({
    super.key,
    required this.globalKey,
    required this.searchController,
    required this.isMain,
    this.onChanged,
    this.pageName,
    this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        // vertical: 20,
      ),
      height: 80,
      decoration: BoxDecoration(
        color: returnTheme(context: context).white(),
        border: Border(
          bottom: BorderSide(
            color: returnTheme(
              context: context,
            ).lightGrey(),
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Visibility(
                  visible:
                      screenSize(context) < tabletScreen,
                  child: InkWell(
                    onTap: () {
                      globalKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      color: returnTheme(
                        context: context,
                      ).darkMediumGrey(),
                      Icons.menu,
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      screenSize(context) < tabletScreen,
                  child: SizedBox(width: 20),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: returnTheme(
                        context: context,
                      ).darkGrey(),
                    ),
                    pageName ??
                        returnNav(
                          context: context,
                        ).pageName(),
                  ),
                ),
                SizedBox(width: 20),
                Visibility(
                  visible:
                      isVisible ??
                      screenSize(context) >=
                              tabletScreenBig &&
                          returnNav(
                                context: context,
                              ).currentPage !=
                              0 &&
                          returnNav(
                                context: context,
                              ).currentPage !=
                              2 &&
                          returnNav(
                                context: context,
                              ).currentPage !=
                              3 &&
                          returnNav(
                                context: context,
                              ).currentPage !=
                              4,
                  child: SizedBox(
                    width:
                        screenSize(context) > tabletScreen
                        ? 350
                        : 300,
                    child: NormalTextfield(
                      inputController: searchController,
                      hintText: 'Search Project Name',
                      title: '',
                      isOptional: true,
                      onChanged: onChanged,
                      showTitle: false,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 5,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (isMain) {
                        returnNav().navigate(4);
                      } else {
                        returnNav().navigate(4);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5,
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                style: TextStyle(
                                  color: returnTheme(
                                    context: context,
                                  ).darkGrey(),
                                  fontSize: 13,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                                returnUser(
                                      context: context,
                                    ).currentUser?.name ??
                                    'No User Found..',
                              ),
                              Text(
                                style: TextStyle(
                                  color: returnTheme(
                                    context: context,
                                  ).darkMediumGrey(),
                                  fontSize: 10,
                                ),
                                returnUser(
                                      context: context,
                                    ).currentUser!.isAdmin
                                    ? 'Admin'
                                    : returnUser(
                                        context: context,
                                      ).currentUser!.email,
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: returnTheme(
                                context: context,
                              ).darkMediumGrey(),
                            ),
                            child: Icon(
                              size: 18,
                              color: returnTheme(
                                context: context,
                              ).lightGrey(),
                              Icons.person,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Visibility(
                  visible: returnUser(
                    context: context,
                  ).currentUser!.isAdmin,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (isMain) {
                          returnNav().navigate(3);
                        } else {
                          returnNav().navigate(3);
                          Navigator.of(context).pop();
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
                                  context: context,
                                ).lightMediumGrey(),
                              ),
                              child: Icon(
                                size: 18,
                                color: returnTheme(
                                  context: context,
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
                                context: context,
                              ).tertiaryColor(),
                            ),
                            child: Center(
                              child: Text(
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 9,
                                  color: returnTheme(
                                    context: context,
                                  ).darkGrey(),
                                ),
                                returnRequest(
                                      context: context,
                                    ).requests
                                    .where(
                                      (req) =>
                                          req.userId !=
                                          null,
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
            ),
          ],
        ),
      ),
    );
  }
}

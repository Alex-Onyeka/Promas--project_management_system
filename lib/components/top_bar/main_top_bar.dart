import 'package:flutter/material.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/user_provider.dart';

class MainTopBar extends StatelessWidget {
  final TextEditingController searchController;
  final bool? isVisible;
  final GlobalKey<ScaffoldState> globalKey;
  final String? pageName;
  final Function(String value)? onChanged;
  const MainTopBar({
    super.key,
    required this.globalKey,
    required this.searchController,
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
        color: returnTheme(context).white(),
        border: Border(
          bottom: BorderSide(
            color: returnTheme(context).lightGrey(),
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
                        context,
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
                        context,
                      ).darkGrey(),
                    ),
                    pageName ??
                        returnNav(context).pageName(),
                  ),
                ),
                SizedBox(width: 20),
                Visibility(
                  visible:
                      isVisible ??
                      screenSize(context) >=
                              tabletScreenBig &&
                          returnNav(context).currentPage !=
                              2 &&
                          returnNav(context).currentPage !=
                              3,
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
                Row(
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
                              context,
                            ).darkGrey(),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          UserProvider()
                                  .currentUser
                                  ?.name ??
                              'No User Found..',
                        ),
                        Text(
                          style: TextStyle(
                            color: returnTheme(
                              context,
                            ).darkMediumGrey(),
                            fontSize: 10,
                          ),
                          UserProvider()
                                  .currentUser!
                                  .isAdmin
                              ? 'Admin'
                              : UserProvider()
                                    .currentUser!
                                    .email,
                        ),
                      ],
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
                              returnRequest(context)
                                  .requests
                                  .where(
                                    (req) =>
                                        req.userId != null,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

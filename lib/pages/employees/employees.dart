import 'package:flutter/material.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/delete_staff_dialog.dart';
import 'package:promas/components/alert_dialogues/edit_user_isadmin_dialog.dart';
import 'package:promas/components/empty_widgets/empty_widget_alt.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/branch_page/branch_page.dart';
import 'package:promas/providers/chats_provider.dart';
import 'package:promas/providers/user_provider.dart';

class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  Future<void> getAllEmployees() async {
    await UserProvider().getAllCompanyUsers();
  }

  Future<void> initFuncs() async {
    await getAllEmployees();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initFuncs();
      if (mounted) {
        setState(() {});
      }
    });
  }

  // final buttonKey = GlobalKey();
  List<UserRoles> userRoles = [
    // UserRoles(role: 'Super Admin', index: 5),
    UserRoles(role: 'Company Admin', index: 4),
    UserRoles(role: 'Project Manager', index: 3),
    UserRoles(role: 'Team Lead', index: 2),
    UserRoles(role: 'Developer', index: 1),
  ];

  void showMenuAction({
    required GlobalKey buttonKey,
    required UserClass user,
  }) async {
    final RenderBox button =
        buttonKey.currentContext!.findRenderObject()
            as RenderBox;

    final Offset position = button.localToGlobal(
      Offset.zero,
    );

    final Size size = button.size;

    final screenSize = MediaQuery.of(context).size;

    await showMenu(
      context: context,
      color: Colors.white,
      constraints: BoxConstraints(
        maxWidth: 500,
        minWidth: 200,
      ),
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 10,
        screenSize.width - position.dx - size.width,
        screenSize.height - position.dy,
      ),
      items: userRoles.map((role) {
        return PopupMenuItem(
          onTap: () {
            makeAdmin(context, user, role.index);
          },
          // value: 'edit',
          child: Text(
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            role.role,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var usersIn = returnUser(context: context).users
        .where(
          (user) =>
              user.id !=
              returnUser(context: context).currentUser!.id,
        )
        .toList();
    usersIn.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: screenSize(context) < tabletScreenSmall
              ? const EdgeInsets.symmetric(horizontal: 0.0)
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
                        context: context,
                      ).darkMediumGrey(),
                    ),
                    'All Staffs',
                  ),
                ],
              ),
              MainDivider(height: 30),
              SizedBox(height: 2),
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Visibility(
                      visible: usersIn.isEmpty,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 30.0,
                        ),
                        child: EmptyWidgetAlt(
                          icon: Icons.person_off_outlined,
                          showButton: false,
                          buttonText: '',
                          title:
                              'No Staff has been added to this Company',
                          action: () async {
                            // await createProject();
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: usersIn.isNotEmpty,
                      child: Column(
                        spacing: 5,
                        children: usersIn
                            .map(
                              (user) => Container(
                                padding:
                                    EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                decoration: BoxDecoration(
                                  color: returnTheme(
                                    context: context,
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
                                          Expanded(
                                            child: Row(
                                              spacing: 5,
                                              children: [
                                                Icon(
                                                  size: 17,
                                                  color: returnTheme(
                                                    context:
                                                        context,
                                                  ).tertiaryLight(),
                                                  Icons
                                                      .person,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    style: TextStyle(
                                                      fontSize:
                                                          11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: returnTheme(
                                                        context:
                                                            context,
                                                      ).darkMediumGrey(),
                                                    ),
                                                    user.name
                                                        .toUpperCase(),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        3,
                                                  ),
                                                  width: 2,
                                                  height:
                                                      18,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    color:
                                                        greyNeutral(),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    style: TextStyle(
                                                      fontSize:
                                                          11,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: returnTheme(
                                                        context:
                                                            context,
                                                      ).mediumGrey(),
                                                    ),
                                                    user.email,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                  top: 0.0,
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                              spacing: 5,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      user.id !=
                                                      returnUser()
                                                          .currentUser
                                                          ?.id,
                                                  child: Material(
                                                    color: Colors
                                                        .transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        openChatPage(
                                                          context: context,
                                                          branchId: null,
                                                          projectId: null,
                                                          chatId: chatId(
                                                            user1: returnUser().currentUser!.id!,
                                                            user2: user.id!,
                                                          ),
                                                          index: 1,
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                          8,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          size: 18,
                                                          color: returnTheme(
                                                            context: context,
                                                          ).secondaryLight(),
                                                          Icons.chat,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: !user
                                                      .isSuperAdmin(),
                                                  child: Material(
                                                    key: user
                                                        .key,
                                                    color: Colors
                                                        .transparent,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        showMenuAction(
                                                          buttonKey: user.key,
                                                          user: user,
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
                                                            Text(
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: returnTheme(
                                                                  context: context,
                                                                ).darkMediumGrey(),
                                                              ),
                                                              user.userRole(),
                                                            ),
                                                            Icon(
                                                              size: 18,
                                                              color: returnTheme(
                                                                context: context,
                                                              ).mediumGrey(),
                                                              Icons.keyboard_arrow_down_rounded,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors
                                                      .transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      deleteStaff(
                                                        context,
                                                        user,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal:
                                                            8.0,
                                                        vertical:
                                                            6,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        spacing:
                                                            5,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
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
                                                            'Delete Staff',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        spacing: 7,
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                        children: [
                                          Row(
                                            spacing: 5,
                                            children: [
                                              Icon(
                                                size: 17,
                                                color: returnTheme(
                                                  context:
                                                      context,
                                                ).tertiaryLight(),
                                                Icons
                                                    .person,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  style: TextStyle(
                                                    fontSize:
                                                        11,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: returnTheme(
                                                      context:
                                                          context,
                                                    ).darkMediumGrey(),
                                                  ),
                                                  user.name
                                                      .toUpperCase(),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      3,
                                                ),
                                                width: 2,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        5,
                                                      ),
                                                  color:
                                                      greyNeutral(),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  style: TextStyle(
                                                    fontSize:
                                                        11,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: returnTheme(
                                                      context:
                                                          context,
                                                    ).mediumGrey(),
                                                  ),
                                                  user.name,
                                                ),
                                              ),
                                            ],
                                          ),
                                          MainDivider(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                  top: 0.0,
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .end,
                                              spacing: 5,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      user.id !=
                                                      returnUser()
                                                          .currentUser
                                                          ?.id,
                                                  child: Material(
                                                    color: Colors
                                                        .transparent,
                                                    child: InkWell(
                                                      onTap: () {
                                                        openChatPage(
                                                          context: context,
                                                          branchId: null,
                                                          projectId: null,
                                                          chatId: chatId(
                                                            user1: returnUser().currentUser!.id!,
                                                            user2: user.id!,
                                                          ),
                                                          index: 1,
                                                        );
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                          8,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          size: 18,
                                                          color: returnTheme(
                                                            context: context,
                                                          ).secondaryLight(),
                                                          Icons.chat,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: !user
                                                      .isSuperAdmin(),
                                                  child: Material(
                                                    key: user
                                                        .key,
                                                    color: Colors
                                                        .transparent,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        showMenuAction(
                                                          buttonKey: user.key,
                                                          user: user,
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
                                                            Text(
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: returnTheme(
                                                                  context: context,
                                                                ).darkMediumGrey(),
                                                              ),
                                                              user.userRole(),
                                                            ),
                                                            Icon(
                                                              size: 18,
                                                              color: returnTheme(
                                                                context: context,
                                                              ).mediumGrey(),
                                                              Icons.keyboard_arrow_down_rounded,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Material(
                                                  color: Colors
                                                      .transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      deleteStaff(
                                                        context,
                                                        user,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal:
                                                            8.0,
                                                        vertical:
                                                            6,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        spacing:
                                                            5,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
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
                                                            'Delete Staff',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
      ),
    );
  }

  Future<dynamic> deleteStaff(
    BuildContext context,
    UserClass user,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return DeleteStaffDialog(user: user);
      },
    );
  }

  Future<dynamic> makeAdmin(
    BuildContext context,
    UserClass user,
    int role,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return EditUserIsAdminDialog(
          user: user,
          role: role,
        );
      },
    );
  }
}

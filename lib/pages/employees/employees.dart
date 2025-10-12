import 'package:flutter/material.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/delete_staff_dialog.dart';
import 'package:promas/components/alert_dialogues/edit_user_isadmin_dialog.dart';
import 'package:promas/components/empty_widgets/empty_widget_alt.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
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

  @override
  Widget build(BuildContext context) {
    var usersIn = returnUser(context).users
        .where(
          (user) =>
              user.id !=
              returnUser(context).currentUser!.id,
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
                        context,
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
                                            spacing: 5,
                                            children: [
                                              Icon(
                                                size: 17,
                                                color: returnTheme(
                                                  context,
                                                ).tertiaryLight(),
                                                Icons
                                                    .person,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      11,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  color: returnTheme(
                                                    context,
                                                  ).darkMediumGrey(),
                                                ),
                                                user.name
                                                    .toUpperCase(),
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
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      11,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  color: returnTheme(
                                                    context,
                                                  ).mediumGrey(),
                                                ),
                                                user.email,
                                              ),
                                            ],
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
                                                  visible: !user
                                                      .isAdmin,
                                                  child: Material(
                                                    color: Colors
                                                        .transparent,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await makeAdmin(
                                                          context,
                                                          user,
                                                          true,
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
                                                              color: returnTheme(
                                                                context,
                                                              ).mediumGrey(),
                                                              Icons.check,
                                                            ),
                                                            Text(
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: returnTheme(
                                                                  context,
                                                                ).darkMediumGrey(),
                                                              ),
                                                              'Make Admin',
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
                                                  context,
                                                ).tertiaryLight(),
                                                Icons
                                                    .person,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      11,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  color: returnTheme(
                                                    context,
                                                  ).darkMediumGrey(),
                                                ),
                                                user.name
                                                    .toUpperCase(),
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
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      11,
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  color: returnTheme(
                                                    context,
                                                  ).mediumGrey(),
                                                ),
                                                user.name,
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
                                                  visible: !user
                                                      .isAdmin,
                                                  child: Material(
                                                    color: Colors
                                                        .transparent,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await makeAdmin(
                                                          context,
                                                          user,
                                                          true,
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
                                                              color: returnTheme(
                                                                context,
                                                              ).mediumGrey(),
                                                              Icons.check,
                                                            ),
                                                            Text(
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: returnTheme(
                                                                  context,
                                                                ).darkMediumGrey(),
                                                              ),
                                                              'Make Admin',
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
    bool boolValue,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return EditUserIsAdminDialog(
          user: user,
          boolValue: boolValue,
        );
      },
    );
  }
}

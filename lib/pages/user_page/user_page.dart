import 'package:flutter/material.dart';
import 'package:promas/components/alert_dialogues/edit_company_dialog.dart';
import 'package:promas/components/alert_dialogues/edit_profile_dialog.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:promas/providers/user_provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  Future<void> getAllUser() async {
    await UserProvider().getCurrentUser();
  }

  Future<void> initFuncs() async {
    await getAllUser();
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 2,
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Builder(
                builder: (context) {
                  if (!returnUser(
                    context,
                  ).currentUser!.isAdmin) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: greyNeutral(),
                        ),
                        color: returnTheme(context).white(),
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: greyNeutral(),
                            ),
                            child: Icon(
                              size: 18,
                              color: returnTheme(
                                context,
                              ).mediumGrey(),
                              Icons.person,
                            ),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: returnTheme(
                                context,
                              ).tertiaryColor(),
                            ),
                            returnUser(
                              context,
                            ).currentUser!.name,
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 10,
                              color: returnTheme(
                                context,
                              ).mediumGrey(),
                            ),
                            returnUser(
                              context,
                            ).currentUser!.email,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            height: 2,
                            width: 300,
                            color: greyNeutral(),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return EditProfileDialog(
                                      nameController:
                                          nameController,
                                      user: UserProvider()
                                          .currentUser!,
                                    );
                                  },
                                ).then((_) {
                                  setState(() {});
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 50.0,
                                      vertical: 10,
                                    ),
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  spacing: 5,
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    Icon(
                                      size: 18,
                                      color: returnTheme(
                                        context,
                                      ).mediumGrey(),
                                      Icons.edit_outlined,
                                    ),
                                    Text(
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: returnTheme(
                                          context,
                                        ).mediumGrey(),
                                      ),
                                      'Edit Profile',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return GridView(
                      gridDelegate:
                          SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 500,
                            mainAxisExtent:
                                screenSize(context) >
                                    tabletScreenSmall
                                ? 300
                                : 200,
                            // childAspectRatio:
                            //     2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: greyNeutral(),
                            ),
                            color: returnTheme(
                              context,
                            ).white(),
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Container(
                                padding: EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: greyNeutral(),
                                ),
                                child: Icon(
                                  size: 18,
                                  color: returnTheme(
                                    context,
                                  ).mediumGrey(),
                                  Icons.person,
                                ),
                              ),
                              Text(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: returnTheme(
                                    context,
                                  ).tertiaryColor(),
                                ),
                                returnUser(
                                  context,
                                ).currentUser!.name,
                              ),
                              Text(
                                style: TextStyle(
                                  fontSize: 10,
                                  color: returnTheme(
                                    context,
                                  ).mediumGrey(),
                                ),
                                returnUser(
                                  context,
                                ).currentUser!.email,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                  bottom: 5,
                                ),
                                height: 2,
                                width: 300,
                                color: greyNeutral(),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return EditProfileDialog(
                                          nameController:
                                              nameController,
                                          user: UserProvider()
                                              .currentUser!,
                                        );
                                      },
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 50.0,
                                          vertical: 10,
                                        ),
                                    child: Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      spacing: 5,
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Icon(
                                          size: 18,
                                          color: returnTheme(
                                            context,
                                          ).mediumGrey(),
                                          Icons
                                              .edit_outlined,
                                        ),
                                        Text(
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: returnTheme(
                                              context,
                                            ).mediumGrey(),
                                          ),
                                          'Edit Profile',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: greyNeutral(),
                            ),
                            color: returnTheme(
                              context,
                            ).white(),
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Container(
                                padding: EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: greyNeutral(),
                                ),
                                child: Icon(
                                  size: 18,
                                  color: returnTheme(
                                    context,
                                  ).mediumGrey(),
                                  Icons.home_work_rounded,
                                ),
                              ),
                              Text(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: returnTheme(
                                    context,
                                  ).tertiaryColor(),
                                ),
                                returnCompany(
                                  context,
                                ).currentCompany!.name,
                              ),
                              Text(
                                style: TextStyle(
                                  fontSize: 10,
                                  color: returnTheme(
                                    context,
                                  ).mediumGrey(),
                                ),
                                returnCompany(context)
                                        .currentCompany!
                                        .desc
                                        .isEmpty
                                    ? 'Company Description Not Set'
                                    : returnCompany(context)
                                          .currentCompany!
                                          .desc,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                  bottom: 5,
                                ),
                                height: 2,
                                width: 300,
                                color: greyNeutral(),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return EditCompanyDialog(
                                          descController:
                                              descController,
                                          nameController:
                                              nameController,
                                          company:
                                              CompanyProvider()
                                                  .currentCompany!,
                                        );
                                      },
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 50.0,
                                          vertical: 10,
                                        ),
                                    child: Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      spacing: 5,
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Icon(
                                          size: 18,
                                          color: returnTheme(
                                            context,
                                          ).mediumGrey(),
                                          Icons
                                              .edit_outlined,
                                        ),
                                        Text(
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: returnTheme(
                                              context,
                                            ).mediumGrey(),
                                          ),
                                          'Edit Company',
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
          ],
        ),
      ),
    );
  }
}

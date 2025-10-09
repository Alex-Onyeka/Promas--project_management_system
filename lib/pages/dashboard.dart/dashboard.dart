import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/components/top_bar/mobile_app_bar.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/employees/employees.dart';
import 'package:promas/pages/projects/projects.dart';
import 'package:promas/providers/company_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  // final companyId = CompanyProvider().currentCompany!.id;
  final projectSearchController = TextEditingController();

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
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                children: [
                                  returnNav(
                                            context,
                                          ).currentPage ==
                                          0
                                      ? MainDashboard(
                                          projectSearchController:
                                              projectSearchController,
                                        )
                                      : returnNav(
                                              context,
                                            ).currentPage ==
                                            1
                                      ? Projects()
                                      : returnNav(
                                              context,
                                            ).currentPage ==
                                            2
                                      ? Employees()
                                      : Container(),
                                ],
                              ),
                            ),
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

class MainDashboard extends StatefulWidget {
  final TextEditingController projectSearchController;
  const MainDashboard({
    super.key,
    required this.projectSearchController,
  });

  @override
  State<MainDashboard> createState() =>
      _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 2,
      children: [
        Row(
          children: [
            Text(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: returnTheme(
                  context,
                ).darkMediumGrey(),
              ),
              'Overview',
            ),
          ],
        ),
        SizedBox(height: 2),
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Stack(
            children: [
              Visibility(
                visible: returnProject(
                  context,
                ).projects.isEmpty,
                child: SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: Column(
                      spacing: 10,
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          size: 35,
                          color: returnTheme(
                            context,
                          ).darkGrey(),
                          Icons.work_off_outlined,
                        ),
                        Text(
                          style: TextStyle(
                            fontSize: 13,
                            color: returnTheme(
                              context,
                            ).darkMediumGrey(),
                          ),
                          'No Projects Created Yet',
                        ),
                        SizedBox(height: 2),
                        SizedBox(
                          width: 200,
                          child: MainButton(
                            action: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AddProjectDialog(
                                    addProject: () {
                                      returnProject(
                                        context,
                                        listen: false,
                                      ).addProject(
                                        ProjectClass(
                                          createdAt:
                                              DateTime.now(),
                                          lastUpdate:
                                              DateTime.now(),
                                          name:
                                              nameController
                                                  .text,
                                          desc:
                                              descController
                                                  .text,
                                          level: 0,
                                          employees: [],
                                          companyId:
                                              CompanyProvider()
                                                  .currentCompany!
                                                  .id,
                                          uuid:
                                              '00 ${returnProject(context, listen: false).projects.length + 1}',
                                        ),
                                      );
                                    },
                                    descController:
                                        descController,
                                    nameController:
                                        nameController,
                                  );
                                },
                              );
                            },
                            title: 'Create New Project',
                          ),
                        ),
                        SizedBox(height: 55),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: returnProject(
                  context,
                  listen: false,
                ).projects.isNotEmpty,
                child: Stack(
                  children: [
                    Visibility(
                      visible: widget
                          .projectSearchController
                          .text
                          .isNotEmpty,
                      child: Stack(
                        children: [
                          Visibility(
                            visible:
                                returnProject(
                                      context,
                                      listen: false,
                                    ).projects
                                    .where(
                                      (pro) => pro.name
                                          .toLowerCase()
                                          .contains(
                                            widget
                                                .projectSearchController
                                                .text
                                                .toLowerCase(),
                                          ),
                                    )
                                    .isNotEmpty,
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300,
                                    mainAxisExtent: 130,
                                    // childAspectRatio:
                                    //     2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              children:
                                  returnProject(
                                        context,
                                        listen: false,
                                      ).projects
                                      .where(
                                        (pro) => pro.name
                                            .toLowerCase()
                                            .contains(
                                              widget
                                                  .projectSearchController
                                                  .text
                                                  .toLowerCase(),
                                            ),
                                      )
                                      .map(
                                        (
                                          project,
                                        ) => ProjectTile(
                                          deleteProject: () {
                                            returnProject(
                                              context,
                                              listen: false,
                                            ).deleteProject(
                                              project,
                                            );
                                          },
                                          project: project,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                          Visibility(
                            visible:
                                returnProject(
                                      context,
                                      listen: false,
                                    ).projects
                                    .where(
                                      (pro) => pro.name
                                          .toLowerCase()
                                          .contains(
                                            widget
                                                .projectSearchController
                                                .text
                                                .toLowerCase(),
                                          ),
                                    )
                                    .isEmpty,
                            child: SizedBox(
                              height: double.infinity,
                              child: Center(
                                child: Column(
                                  spacing: 10,
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    Icon(
                                      size: 35,
                                      color: returnTheme(
                                        context,
                                      ).darkGrey(),
                                      Icons
                                          .work_off_outlined,
                                    ),
                                    Text(
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: returnTheme(
                                          context,
                                        ).darkMediumGrey(),
                                      ),
                                      'No Projects Found',
                                    ),
                                    SizedBox(height: 2),
                                    SizedBox(
                                      width: 200,
                                      child: MainButton(
                                        action: () {
                                          setState(() {
                                            widget
                                                .projectSearchController
                                                .clear();
                                          });
                                        },
                                        title:
                                            'Clear Search',
                                      ),
                                    ),
                                    SizedBox(height: 55),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget
                          .projectSearchController
                          .text
                          .isEmpty,
                      child: GridView(
                        gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              mainAxisExtent: 130,
                              // childAspectRatio:
                              //     2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        children: [
                          Builder(
                            builder: (context) {
                              if (returnProject(
                                context,
                                listen: false,
                              ).projects.isNotEmpty) {
                                return ProjectTile(
                                  deleteProject: () {
                                    returnProject(
                                      context,
                                      listen: false,
                                    ).deleteProject(
                                      returnProject(
                                        context,
                                        listen: false,
                                      ).projects[0],
                                    );
                                  },
                                  project: returnProject(
                                    context,
                                    listen: false,
                                  ).projects[0],
                                );
                              } else {
                                return Visibility(
                                  visible: returnProject(
                                    context,
                                    listen: false,
                                  ).projects.isNotEmpty,
                                  child: Container(
                                    color: Colors.amber,
                                  ),
                                );
                              }
                            },
                          ),
                          Builder(
                            builder: (context) {
                              if (returnProject(
                                    context,
                                    listen: false,
                                  ).projects.length >
                                  1) {
                                return ProjectTile(
                                  deleteProject: () {
                                    returnProject(
                                      context,
                                      listen: false,
                                    ).deleteProject(
                                      returnProject(
                                        context,
                                        listen: false,
                                      ).projects[1],
                                    );
                                  },
                                  project: returnProject(
                                    context,
                                    listen: false,
                                  ).projects[1],
                                );
                              } else {
                                return Visibility(
                                  visible:
                                      returnProject(
                                        context,
                                        listen: false,
                                      ).projects.length >
                                      1,
                                  child: Container(
                                    color: Colors.amber,
                                  ),
                                );
                              }
                            },
                          ),
                          Builder(
                            builder: (context) {
                              if (returnProject(
                                    context,
                                    listen: false,
                                  ).projects.length >
                                  2) {
                                return ProjectTile(
                                  deleteProject: () {
                                    returnProject(
                                      context,
                                      listen: false,
                                    ).deleteProject(
                                      returnProject(
                                        context,
                                        listen: false,
                                      ).projects[2],
                                    );
                                  },
                                  project: returnProject(
                                    context,
                                    listen: false,
                                  ).projects[2],
                                );
                              } else {
                                return Visibility(
                                  visible:
                                      returnProject(
                                        context,
                                        listen: false,
                                      ).projects.length >
                                      2,
                                  child: Container(
                                    color: Colors.amber,
                                  ),
                                );
                              }
                            },
                          ),
                          AddProjectMainTile(
                            action: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AddProjectDialog(
                                    addProject: () {
                                      returnProject(
                                        context,
                                        listen: false,
                                      ).addProject(
                                        ProjectClass(
                                          createdAt:
                                              DateTime.now(),
                                          lastUpdate:
                                              DateTime.now(),
                                          name:
                                              nameController
                                                  .text,
                                          desc:
                                              descController
                                                  .text,
                                          level: 0,
                                          employees: [],
                                          companyId:
                                              CompanyProvider()
                                                  .currentCompany!
                                                  .id,
                                          uuid:
                                              '00 ${returnProject(context, listen: false).projects.length + 1}',
                                        ),
                                      );
                                    },
                                    descController:
                                        descController,
                                    nameController:
                                        nameController,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddProjectDialog extends StatefulWidget {
  final Function() addProject;
  final TextEditingController nameController;
  final TextEditingController descController;
  const AddProjectDialog({
    super.key,
    required this.addProject,
    required this.nameController,
    required this.descController,
  });

  @override
  State<AddProjectDialog> createState() =>
      _AddProjectDialogState();
}

class _AddProjectDialogState
    extends State<AddProjectDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertPlaceholder(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            HeadingSection(
              title: 'Create New Project',
              subText:
                  'Fill The Form To Create New Project',
            ),
            SizedBox(height: 10),
            NormalTextfield(
              inputController: widget.nameController,
              hintText: 'Enter Project Name',
              title: 'Project Name',
              isOptional: false,
            ),
            SizedBox(height: 3),
            NormalTextfield(
              inputController: widget.descController,
              hintText: 'Enter Project Description',
              title: 'Project Description',
              isOptional: false,
              numberOfLines: 3,
            ),
            SizedBox(height: 6),
            MainButton(
              action: () {
                if (_formKey.currentState!.validate()) {
                  widget.addProject();
                  Navigator.of(context).pop();
                }
              },
              title: 'Create Project',
            ),
            SizedBox(height: 4),
            SecondaryButton(
              title: 'Cancel',
              action: () {
                widget.nameController.clear();
                widget.descController.clear();
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class AddProjectMainTile extends StatelessWidget {
  final Function() action;
  const AddProjectMainTile({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: mainBorderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(10, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
        color: returnTheme(context).white(),
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: mainBorderRadius,
            color: returnTheme(context).white(),
          ),
          child: InkWell(
            borderRadius: mainBorderRadius,
            onTap: action,
            child: Container(
              width: 260,
              height: 125,
              padding: EdgeInsets.fromLTRB(5, 15, 15, 15),
              child: Center(
                child: Icon(
                  size: 35,
                  color: theme.tertiaryColor(),
                  Icons.add,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectTile extends StatelessWidget {
  final ProjectClass project;
  final Function() deleteProject;
  const ProjectTile({
    super.key,
    required this.project,
    required this.deleteProject,
  });

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context);
    var screen = screenSize(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: mainBorderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(10, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
        color: returnTheme(context).white(),
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: mainBorderRadius,
            color: returnTheme(context).white(),
          ),
          child: InkWell(
            borderRadius: mainBorderRadius,
            onTap: deleteProject,
            child: Container(
              // width: 260,
              // height: 125,
              padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.lightMediumGrey(),
                        ),
                        child: Icon(
                          size: 12,
                          color: theme.darkMediumGrey(),
                          Icons.workspace_premium_rounded,
                        ),
                      ),
                      SizedBox(
                        width: screen > mobileScreen
                            ? 10
                            : 8,
                      ),
                      Flexible(
                        child: Text(
                          style: TextStyle(
                            fontSize: screen > mobileScreen
                                ? 14
                                : 12,
                            color: theme.darkMediumGrey(),
                            fontWeight: FontWeight.bold,
                          ),
                          cutLongText(
                            screen > mobileScreen ? 20 : 16,
                            project.name,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: screen > mobileScreen
                                ? const EdgeInsets.only(
                                    left: 15.0,
                                  )
                                : const EdgeInsets.only(
                                    left: 10,
                                  ),
                            child: Text(
                              style: TextStyle(
                                fontSize:
                                    screen > mobileScreen
                                    ? 10
                                    : 8,
                                color: theme.mediumGrey(),
                              ),
                              cutLongText(
                                screen > mobileScreen
                                    ? 80
                                    : 70,
                                project.desc,
                              ),
                              // 'Project Description is the way of Life and Beans',
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          color: theme.lightMediumGrey(),
                        ),
                        Padding(
                          padding: screen > mobileScreen
                              ? const EdgeInsets.only(
                                  left: 15.0,
                                )
                              : const EdgeInsets.only(
                                  left: 10,
                                ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              Row(
                                spacing: 5,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      Text(
                                        style: TextStyle(
                                          fontSize:
                                              screen >
                                                  mobileScreen
                                              ? 8
                                              : 6,
                                          color: theme
                                              .darkMediumGrey(),
                                        ),
                                        'Staffs:',
                                      ),
                                      Text(
                                        style: TextStyle(
                                          fontSize:
                                              screen >
                                                  mobileScreen
                                              ? 8
                                              : 7,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color: theme
                                              .darkMediumGrey(),
                                        ),
                                        project
                                            .employees
                                            .length
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 13,
                                    width: 1,
                                    color: returnTheme(
                                      context,
                                    ).lightMediumGrey(),
                                  ),
                                  Row(
                                    spacing: 5,
                                    children: [
                                      Text(
                                        style: TextStyle(
                                          fontSize:
                                              screen >
                                                  mobileScreen
                                              ? 8
                                              : 6,
                                          color: theme
                                              .darkMediumGrey(),
                                        ),
                                        'Updated:',
                                      ),
                                      Text(
                                        style: TextStyle(
                                          fontSize:
                                              screen >
                                                  mobileScreen
                                              ? 8
                                              : 7,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color: theme
                                              .darkMediumGrey(),
                                        ),
                                        formatShortDateTwo(
                                          project
                                              .lastUpdate,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                size: screen > mobileScreen
                                    ? 14
                                    : 12,
                                color: theme
                                    .darkMediumGrey(),
                                Icons
                                    .arrow_forward_ios_rounded,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

class RightSideBar extends StatefulWidget {
  const RightSideBar({super.key});

  @override
  State<RightSideBar> createState() => _RightSideBarState();
}

class _RightSideBarState extends State<RightSideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenSize(context) > mobileScreen
          ? 170
          : null,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: const Color.fromARGB(24, 148, 148, 148),
          ),
        ),
      ),
      child: Column(
        spacing: 8,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 8,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(5),
                          color: returnTheme(
                            context,
                          ).tertiaryLight(),
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              style: TextStyle(
                                height: 0,
                                fontSize: 25,
                                color: Colors.grey.shade900,
                              ),
                              formatTime(DateTime.now()),
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Icon(
                                  size: 13,
                                  returnGreetingIcon(),
                                ),
                                Flexible(
                                  child: Text(
                                    textAlign:
                                        TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors
                                          .grey
                                          .shade900,
                                    ),
                                    returnGreetingText(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment(1.1, 1.5),
                        child: IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(
                            size: 15,
                            Icons.refresh,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      color: returnTheme(
                        context,
                      ).secondaryLight(),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          style: TextStyle(
                            height: 0,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          formatShortDate(DateTime.now()),
                        ),
                        Flexible(
                          child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white,
                            ),
                            formatFullDate(DateTime.now()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

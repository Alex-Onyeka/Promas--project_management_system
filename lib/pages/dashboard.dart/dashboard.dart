import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/components/top_bar/mobile_app_bar.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
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

  List<ProjectClass> projects = [
    ProjectClass(
      uuid: 'No 1',
      createdAt: DateTime.now(),
      lastUpdate: DateTime.now(),
      name: 'Stockall Application Development',
      desc: 'An Inventory Management System',
      level: 0,
      employees: [],
      companyId: CompanyProvider().currentCompany!.id,
    ),
    ProjectClass(
      uuid: 'No 2',
      createdAt: DateTime.now(),
      lastUpdate: DateTime.now(),
      name: 'Promas Project Management System',
      desc:
          'An Project Management System, designed for company staff relationship and management. Project Management...',
      level: 0,
      employees: [],
      companyId: CompanyProvider().currentCompany!.id,
    ),
    ProjectClass(
      uuid: 'No 3',
      createdAt: DateTime.now(),
      lastUpdate: DateTime.now(),
      name: 'Social Media Platform',
      desc:
          'An Digital Management Platform where users can share posts and create social experiences.',
      level: 0,
      employees: [],
      companyId: CompanyProvider().currentCompany!.id,
    ),
  ];

  void addProject(ProjectClass project) {
    setState(() {
      projects.add(project);
    });
  }

  void deleteProject(ProjectClass project) {
    setState(() {
      projects.remove(project);
    });
  }

  void updateProject(ProjectClass project) {
    setState(() {
      projects.removeWhere(
        (pro) => pro.uuid! == project.uuid,
      );
      projects.add(project);
    });
  }

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
                                  Column(
                                    spacing: 2,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
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
                                        // height: 300,
                                        width:
                                            double.infinity,
                                        child: Stack(
                                          children: [
                                            Visibility(
                                              visible: projects
                                                  .isEmpty,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    Text(
                                                      'No Projects Created Yet',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: projects
                                                  .isNotEmpty,
                                              child: Stack(
                                                children: [
                                                  Visibility(
                                                    visible: projectSearchController
                                                        .text
                                                        .isEmpty,
                                                    child: Wrap(
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment.start,
                                                      runSpacing:
                                                          15,
                                                      spacing:
                                                          15,
                                                      runAlignment:
                                                          WrapAlignment.start,
                                                      children: [
                                                        Builder(
                                                          builder:
                                                              (
                                                                context,
                                                              ) {
                                                                if (projects.isNotEmpty) {
                                                                  return ProjectTile(
                                                                    project: projects[0],
                                                                  );
                                                                } else {
                                                                  return Visibility(
                                                                    visible: projects.isNotEmpty,
                                                                    child: Container(
                                                                      color: Colors.amber,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                        ),
                                                        Builder(
                                                          builder:
                                                              (
                                                                context,
                                                              ) {
                                                                if (projects.length >
                                                                    1) {
                                                                  return ProjectTile(
                                                                    project: projects[1],
                                                                  );
                                                                } else {
                                                                  return Visibility(
                                                                    visible:
                                                                        projects.length >
                                                                        1,
                                                                    child: Container(
                                                                      color: Colors.amber,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                        ),
                                                        Builder(
                                                          builder:
                                                              (
                                                                context,
                                                              ) {
                                                                if (projects.length >
                                                                    2) {
                                                                  return ProjectTile(
                                                                    project: projects[2],
                                                                  );
                                                                } else {
                                                                  return Visibility(
                                                                    visible:
                                                                        projects.length >
                                                                        2,
                                                                    child: Container(
                                                                      color: Colors.amber,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                        ),
                                                        Builder(
                                                          builder:
                                                              (
                                                                context,
                                                              ) {
                                                                if (projects.length >
                                                                    3) {
                                                                  return ProjectTile(
                                                                    project: projects[3],
                                                                  );
                                                                } else {
                                                                  return Visibility(
                                                                    visible:
                                                                        projects.length >
                                                                        3,
                                                                    child: Container(
                                                                      color: Colors.amber,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                        ),
                                                        AddProjectMainTile(),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: projectSearchController
                                                        .text
                                                        .isNotEmpty,
                                                    child: Wrap(
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment.start,
                                                      runSpacing:
                                                          15,
                                                      spacing:
                                                          15,
                                                      runAlignment:
                                                          WrapAlignment.start,
                                                      children: projects
                                                          .where(
                                                            (
                                                              pro,
                                                            ) => pro.name.toLowerCase().contains(
                                                              projectSearchController.text.toLowerCase(),
                                                            ),
                                                          )
                                                          .map(
                                                            (
                                                              project,
                                                            ) => ProjectTile(
                                                              project: project,
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
                                    ],
                                  ),
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

class AddProjectMainTile extends StatelessWidget {
  const AddProjectMainTile({super.key});

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
            onTap: () {},
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
  const ProjectTile({super.key, required this.project});

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
            onTap: () {},
            child: Container(
              width: 260,
              height: 125,
              padding: EdgeInsets.fromLTRB(5, 15, 15, 15),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.lightMediumGrey(),
                        ),
                        child: Icon(
                          size: 13,
                          color: theme.darkMediumGrey(),
                          Icons.workspace_premium_rounded,
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.darkGrey(),
                            fontWeight: FontWeight.bold,
                          ),
                          cutLongText(20, project.name),
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
                            padding: const EdgeInsets.only(
                              left: 15.0,
                            ),
                            child: Text(
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.darkGrey(),
                              ),
                              cutLongText(80, project.desc),
                              // 'Project Description is the way of Life and Beans',
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                          color: theme.lightMediumGrey(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
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
                                          fontSize: 8,
                                          color: theme
                                              .darkMediumGrey(),
                                        ),
                                        'Staffs:',
                                      ),
                                      Text(
                                        style: TextStyle(
                                          fontSize: 8,
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
                                          fontSize: 8,
                                          color: theme
                                              .darkMediumGrey(),
                                        ),
                                        'Updated:',
                                      ),
                                      Text(
                                        style: TextStyle(
                                          fontSize: 8,
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
                                size: 14,
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

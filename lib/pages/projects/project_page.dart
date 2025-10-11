import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/add_branch_dialog.dart';
import 'package:promas/components/alert_dialogues/add_project_dialog.dart';
import 'package:promas/components/alert_dialogues/confirm_alert.dart';
import 'package:promas/components/alert_dialogues/select_staff_dialog.dart';
import 'package:promas/components/empty_widgets/empty_widget_alt.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/side_bar/right_side_bar.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/components/top_bar/mobile_app_bar.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/company_provider.dart';

class ProjectPage extends StatefulWidget {
  final ProjectClass project;
  const ProjectPage({super.key, required this.project});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  // final companyId = CompanyProvider().currentCompany!.id;
  final projectSearchController = TextEditingController();
  final nameController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: screenSize(context) > mobileScreen
          ? null
          : appBar(context: context),
      drawer: MainSideBar(isMain: false),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: screenSize(context) > tabletScreen,
            child: MainSideBar(isMain: false),
          ),
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible:
                      screenSize(context) > mobileScreen,
                  child: MainTopBar(
                    pageName: 'Project Page',
                    isVisible: false,
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
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(
                                            context,
                                          ).pop();
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(
                                                4.0,
                                              ),
                                          child: Icon(
                                            size: 20,
                                            color:
                                                returnTheme(
                                                  context,
                                                ).darkGrey(),
                                            Icons
                                                .arrow_back_ios_new_rounded,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign
                                            .center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              returnTheme(
                                                context,
                                              ).darkGrey(),
                                        ),
                                        widget.project.name,
                                      ),
                                      Opacity(
                                        opacity: 0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(
                                                4.0,
                                              ),
                                          child: Icon(
                                            size: 20,
                                            color:
                                                returnTheme(
                                                  context,
                                                ).darkGrey(),
                                            Icons
                                                .arrow_back_ios_new_rounded,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  MainDivider(height: 10),
                                  SizedBox(height: 8),
                                  Text(
                                    textAlign:
                                        TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.normal,
                                      color: returnTheme(
                                        context,
                                      ).darkMediumGrey(),
                                    ),
                                    widget.project.desc,
                                  ),
                                  SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    spacing: 5,
                                    children: [
                                      DashboardContainers(
                                        text:
                                            'Created Date',
                                        title: formateDate(
                                          widget
                                              .project
                                              .createdAt,
                                        ),
                                      ),
                                      DashboardContainers(
                                        text:
                                            'Progress Level',
                                        title: calcPercentage(
                                          returnBranch(
                                                context,
                                                listen:
                                                    false,
                                              ).branches
                                              .where(
                                                (bra) =>
                                                    bra.projectId ==
                                                    widget
                                                        .project
                                                        .uuid,
                                              )
                                              .toList()
                                              .map(
                                                (bra) => bra
                                                    .level,
                                              )
                                              .toList(),
                                        ),
                                      ),
                                      DashboardContainers(
                                        text:
                                            'Last Updated',
                                        title: formateDate(
                                          widget
                                              .project
                                              .lastUpdate,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    spacing: 10,
                                    children: [
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
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context:
                                                      context,
                                                  builder: (context) {
                                                    return AddProjectDialog(
                                                      project:
                                                          widget.project,
                                                      addProject: () {
                                                        returnProject(
                                                          context,
                                                          listen: false,
                                                        ).updateProject(
                                                          ProjectClass(
                                                            uuid: widget.project.uuid,
                                                            createdAt: widget.project.createdAt,
                                                            lastUpdate: DateTime.now(),
                                                            name: nameController.text,
                                                            desc: descController.text,
                                                            level: widget.project.level,
                                                            companyId: widget.project.companyId,
                                                            employees: [],
                                                          ),
                                                        );
                                                      },
                                                      nameController:
                                                          nameController,
                                                      descController:
                                                          descController,
                                                    );
                                                  },
                                                ).then((_) {
                                                  setState(
                                                    () {},
                                                  );
                                                });
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
                                                      MainAxisSize
                                                          .min,
                                                  spacing:
                                                      5,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    Icon(
                                                      size:
                                                          18,
                                                      color: returnTheme(
                                                        context,
                                                      ).mediumGrey(),
                                                      Icons
                                                          .edit_outlined,
                                                    ),
                                                    Text(
                                                      style: TextStyle(
                                                        fontSize:
                                                            11,
                                                        color: returnTheme(
                                                          context,
                                                        ).mediumGrey(),
                                                      ),
                                                      'Edit Project',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context:
                                                      context,
                                                  builder: (context) {
                                                    return ConfirmAlert(
                                                      buttonText:
                                                          'Delete Project',
                                                      action: () {
                                                        returnProject(
                                                          context,
                                                          listen: false,
                                                        ).deleteProject(
                                                          widget.project,
                                                        );
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                      subText:
                                                          'Are you sure you want to delete this project?',
                                                      title:
                                                          'Delete Project?',
                                                    );
                                                  },
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
                                                      MainAxisSize
                                                          .min,
                                                  spacing:
                                                      5,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    Icon(
                                                      size:
                                                          18,
                                                      color: const Color.fromARGB(
                                                        255,
                                                        255,
                                                        92,
                                                        92,
                                                      ),
                                                      Icons
                                                          .delete_outlined,
                                                    ),
                                                    Text(
                                                      style: TextStyle(
                                                        fontSize:
                                                            11,
                                                        color: const Color.fromARGB(
                                                          255,
                                                          255,
                                                          92,
                                                          92,
                                                        ),
                                                      ),
                                                      'Delete Project',
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
                                  SizedBox(height: 10),
                                  MainDivider(height: 10),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        spacing: 5,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print(
                                                returnBranch(
                                                  context,
                                                  listen:
                                                      false,
                                                ).branches.length,
                                              );
                                            },
                                            child: Text(
                                              style: TextStyle(
                                                fontSize:
                                                    11,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                                color: returnTheme(
                                                  context,
                                                ).darkGrey(),
                                              ),
                                              'BRANCHES',
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await createBranch(
                                                context:
                                                    context,
                                                descController:
                                                    descController,
                                                nameController:
                                                    nameController,
                                                projectId: widget
                                                    .project
                                                    .uuid!,
                                              );
                                              setState(
                                                () {},
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.symmetric(
                                                    vertical:
                                                        10,
                                                    horizontal:
                                                        10,
                                                  ),
                                              child: Row(
                                                spacing: 3,
                                                children: [
                                                  Icon(
                                                    color: returnTheme(
                                                      context,
                                                    ).darkMediumGrey(),
                                                    size:
                                                        18,
                                                    Icons
                                                        .add,
                                                  ),
                                                  Text(
                                                    style: TextStyle(
                                                      fontSize:
                                                          11,
                                                      color: returnTheme(
                                                        context,
                                                      ).darkMediumGrey(),
                                                    ),
                                                    'Create New Branch',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (returnBranch(
                                                context,
                                              ).branches
                                              .where(
                                                (branch) =>
                                                    branch
                                                        .projectId ==
                                                    widget
                                                        .project
                                                        .uuid,
                                              )
                                              .isNotEmpty) {
                                            return Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal:
                                                        20.0,
                                                    vertical:
                                                        5,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: returnTheme(
                                                              context,
                                                            ).mediumGrey(),
                                                          ),
                                                          'Branch Name',
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: returnTheme(
                                                              context,
                                                            ).mediumGrey(),
                                                          ),
                                                          'Level',
                                                        ),
                                                      ),
                                                      Opacity(
                                                        opacity:
                                                            0,
                                                        child: Icon(
                                                          Icons.keyboard_arrow_up_rounded,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  children: returnBranch(context)
                                                      .branches
                                                      .where(
                                                        (
                                                          branch,
                                                        ) =>
                                                            branch.projectId ==
                                                            widget.project.uuid,
                                                      )
                                                      .map(
                                                        (
                                                          branch,
                                                        ) => BranchListTile(
                                                          action: () {
                                                            setState(
                                                              () {},
                                                            );
                                                          },
                                                          descController: descController,
                                                          nameController: nameController,
                                                          branch: branch,
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return EmptyWidgetAlt(
                                              buttonText:
                                                  'Create branch',
                                              title:
                                                  'No Branch for This Project',
                                              action: () => createBranch(
                                                context:
                                                    context,
                                                descController:
                                                    descController,
                                                nameController:
                                                    nameController,
                                                projectId: widget
                                                    .project
                                                    .uuid!,
                                              ),
                                            );
                                          }
                                        },
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

class BranchListTile extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final BranchClass branch;
  final Function() action;
  const BranchListTile({
    super.key,
    required this.branch,
    required this.nameController,
    required this.descController,
    required this.action,
  });

  @override
  State<BranchListTile> createState() =>
      _BranchListTileState();
}

class _BranchListTileState extends State<BranchListTile> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Ink(
        decoration: BoxDecoration(
          color: returnTheme(context).white(),
          borderRadius: mainBorderRadius,
          border: Border.all(
            color: const Color.fromARGB(20, 66, 66, 66),
          ),
        ),
        child: SizedBox(
          child: Column(
            children: [
              Ink(
                child: InkWell(
                  borderRadius: mainBorderRadius,
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            style: TextStyle(
                              fontSize: 13,
                              color: returnTheme(
                                context,
                              ).darkGrey(),
                            ),
                            widget.branch.name,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            style: TextStyle(
                              fontSize: 11,
                              color: returnTheme(
                                context,
                              ).darkGrey(),
                            ),
                            calcPercentageSingle(
                              widget.branch.level,
                            ),
                          ),
                        ),
                        Icon(
                          size: 20,
                          color: returnTheme(
                            context,
                          ).mediumGrey(),
                          isOpen
                              ? Icons
                                    .keyboard_arrow_up_sharp
                              : Icons
                                    .keyboard_arrow_down_sharp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isOpen,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    15,
                    0,
                    15,
                    15,
                  ),
                  child: Column(
                    children: [
                      MainDivider(height: 15),
                      Visibility(
                        visible: widget.branch.desc != null,
                        child: Row(
                          children: [
                            Text(
                              style: TextStyle(
                                fontSize: 11,
                                color: returnTheme(
                                  context,
                                ).darkMediumGrey(),
                              ),
                              widget.branch.desc ?? '',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height:
                            screenSize(context) <=
                                tabletScreenSmall
                            ? 220
                            : 190,
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent:
                                    screenSize(context) <=
                                        tabletScreenSmall
                                    ? 500
                                    : 500,
                                mainAxisExtent: 160,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: Colors.grey,
                                // ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: returnTheme(
                                            context,
                                          ).darkMediumGrey(),
                                        ),
                                        'Active Staffs:',
                                      ),
                                    ],
                                  ),
                                  // MainDivider(height: 15),
                                  SizedBox(height: 10),
                                  Builder(
                                    builder: (context) {
                                      if (returnUser(
                                            context,
                                          ).users
                                          .where(
                                            (user) => widget
                                                .branch
                                                .employees
                                                .contains(
                                                  user.id,
                                                ),
                                          )
                                          .toList()
                                          .isEmpty) {
                                        return Center(
                                          child: Column(
                                            mainAxisSize:
                                                MainAxisSize
                                                    .min,
                                            spacing: 3,
                                            children: [
                                              Icon(
                                                size: 15,
                                                color: returnTheme(
                                                  context,
                                                ).mediumGrey(),
                                                Icons
                                                    .person,
                                              ),
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      11,
                                                  color: returnTheme(
                                                    context,
                                                  ).darkGrey(),
                                                ),
                                                'No Staff Added to this Project',
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context:
                                                        context,
                                                    builder:
                                                        (
                                                          context,
                                                        ) {
                                                          return StatefulBuilder(
                                                            builder:
                                                                (
                                                                  context,
                                                                  setState,
                                                                ) {
                                                                  return SelectStaffDialog(
                                                                    branch: widget.branch,
                                                                    selectStaff: () {},
                                                                  );
                                                                },
                                                          );
                                                        },
                                                  ).then((
                                                    _,
                                                  ) {
                                                    setState(
                                                      () {},
                                                    );
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical:
                                                        3.0,
                                                    horizontal:
                                                        10,
                                                  ),
                                                  child: Row(
                                                    spacing:
                                                        5,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        size:
                                                            15,
                                                        color: returnTheme(
                                                          context,
                                                        ).secondaryColor(),
                                                        Icons.add,
                                                      ),
                                                      Text(
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: returnTheme(
                                                            context,
                                                          ).secondaryColor(),
                                                        ),
                                                        'Add Staff',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return SingleChildScrollView(
                                          child: Column(
                                            spacing: 5,
                                            children: returnUser(context)
                                                .users
                                                .where(
                                                  (
                                                    user,
                                                  ) => widget
                                                      .branch
                                                      .employees
                                                      .contains(
                                                        user.id,
                                                      ),
                                                )
                                                .toList()
                                                .map(
                                                  (
                                                    use,
                                                  ) => Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: const Color.fromARGB(
                                                            31,
                                                            66,
                                                            66,
                                                            66,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          10,
                                                      horizontal:
                                                          10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      spacing:
                                                          5,
                                                      children: [
                                                        Row(
                                                          spacing: 5,
                                                          children: [
                                                            Icon(
                                                              size: 15,
                                                              color: returnTheme(
                                                                context,
                                                              ).mediumGrey(),
                                                              Icons.person,
                                                            ),
                                                            Text(
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: returnTheme(
                                                                  context,
                                                                ).darkGrey(),
                                                              ),
                                                              use.name,
                                                            ),
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) {
                                                                    return ConfirmAlert(
                                                                      buttonText: 'Remove Staff',
                                                                      action: () {
                                                                        returnBranch(
                                                                          context,
                                                                          listen: false,
                                                                        ).removeStaffFromBranch(
                                                                          widget.branch,
                                                                          use,
                                                                        );
                                                                      },
                                                                      subText: 'Are you sure you want to remove this staff from the Branch?',
                                                                      title: 'Remove Staff?',
                                                                    );
                                                                  },
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
                                                                context,
                                                              ).mediumGrey(),
                                                              Icons.clear,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              spacing: 5,
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(
                                            18,
                                            66,
                                            66,
                                            66,
                                          ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        spacing: 2,
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                        children: [
                                          Text(
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: returnTheme(
                                                context,
                                              ).darkMediumGrey(),
                                            ),
                                            'Created Date:',
                                          ),
                                          Text(
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              color: returnTheme(
                                                context,
                                              ).darkMediumGrey(),
                                            ),
                                            formateDate(
                                              widget
                                                  .branch
                                                  .createdAt,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(
                                            18,
                                            66,
                                            66,
                                            66,
                                          ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        spacing: 2,
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                        children: [
                                          Text(
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: returnTheme(
                                                context,
                                              ).darkMediumGrey(),
                                            ),
                                            'Last Updated:',
                                          ),
                                          Text(
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              color: returnTheme(
                                                context,
                                              ).darkMediumGrey(),
                                            ),
                                            formateDate(
                                              widget
                                                  .branch
                                                  .lastUpdate,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(
                                        top: 15.0,
                                      ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .end,
                                    spacing: 5,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await createBranch(
                                            branch: widget
                                                .branch,
                                            context:
                                                context,
                                            descController:
                                                widget
                                                    .descController,
                                            nameController:
                                                widget
                                                    .nameController,
                                            projectId: widget
                                                .branch
                                                .projectId,
                                          );
                                          widget.action();
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                horizontal:
                                                    8.0,
                                                vertical: 6,
                                              ),
                                          child: Row(
                                            mainAxisSize:
                                                MainAxisSize
                                                    .min,
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
                                                  fontSize:
                                                      11,
                                                  color: returnTheme(
                                                    context,
                                                  ).mediumGrey(),
                                                ),
                                                'Edit Branch',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context:
                                                context,
                                            builder: (context) {
                                              return ConfirmAlert(
                                                buttonText:
                                                    'Delete Branch',
                                                action: () {
                                                  returnBranch(
                                                    context,
                                                    listen:
                                                        false,
                                                  ).deleteBranchTemp(
                                                    widget
                                                        .branch,
                                                  );
                                                },
                                                subText:
                                                    'Are you sure you want to delete this Branch?',
                                                title:
                                                    'Delete Branch?',
                                              );
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                horizontal:
                                                    8.0,
                                                vertical: 6,
                                              ),
                                          child: Row(
                                            mainAxisSize:
                                                MainAxisSize
                                                    .min,
                                            spacing: 5,
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                            children: [
                                              Icon(
                                                size: 18,
                                                color:
                                                    const Color.fromARGB(
                                                      255,
                                                      255,
                                                      92,
                                                      92,
                                                    ),
                                                Icons
                                                    .delete_outlined,
                                              ),
                                              Text(
                                                style: TextStyle(
                                                  fontSize:
                                                      11,
                                                  color:
                                                      const Color.fromARGB(
                                                        255,
                                                        255,
                                                        92,
                                                        92,
                                                      ),
                                                ),
                                                'Delete Branch',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardContainers extends StatelessWidget {
  const DashboardContainers({
    super.key,
    required this.title,
    required this.text,
  });

  final String? title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(36, 33, 33, 33),
          ),
          borderRadius: mainBorderRadius,
        ),
        child: Center(
          child: Column(
            spacing: 2,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: returnTheme(context).mediumGrey(),
                ),
                text,
              ),
              Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: returnTheme(
                    context,
                  ).darkMediumGrey(),
                ),
                title ?? 'Not Set',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> createBranch({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController descController,
  required String projectId,
  BranchClass? branch,
}) async {
  await showDialog(
    context: context,
    builder: (contxt) {
      return AddBranchDialog(
        branch: branch,
        addBranch: () {
          if (branch == null) {
            print('Creating Branch');
            returnBranch(
              context,
              listen: false,
            ).addBranchTemp(
              BranchClass(
                uuid:
                    'No ${returnBranch(context, listen: false).branches.length + 1}',
                name: nameController.text.trim(),
                projectId: projectId,
                createdAt: DateTime.now(),
                lastUpdate: DateTime.now(),
                level: 0,
                desc: descController.text,
                employees:
                    returnBranch(context, listen: false)
                        .selectedStaffs
                        .map((staf) => staf.id ?? '')
                        .toList(),
                companyId:
                    CompanyProvider().currentCompany!.id!,
              ),
            );
          } else {
            print('Updating Branch');
            returnBranch(
              context,
              listen: false,
            ).updateBranchTemp(
              BranchClass(
                uuid: branch.uuid,
                name: nameController.text.trim(),
                projectId: projectId,
                createdAt: branch.createdAt,
                lastUpdate: DateTime.now(),
                level: branch.level + 10,
                desc: descController.text.trim(),
                employees:
                    returnBranch(context, listen: false)
                        .selectedStaffs
                        .map((staf) => staf.id ?? '')
                        .toList(),
                companyId:
                    CompanyProvider().currentCompany!.id!,
              ),
            );
          }
        },
        nameController: nameController,
        descController: descController,
      );
    },
  ).then((_) {
    returnBranch(
      context,
      listen: false,
    ).clearSelectedStaffs();
  });
}

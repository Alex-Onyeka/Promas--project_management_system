import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/add_branch_dialog.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/side_bar/right_side_bar.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/components/top_bar/mobile_app_bar.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/dashboard.dart/dashboard.dart';
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

  void createBranch() {
    showDialog(
      context: context,
      builder: (contxt) {
        return AddBranchDialog(
          addBranch: () {
            returnBranch(
              context,
              listen: false,
            ).addBranchTemp(
              BranchClass(
                uuid:
                    'No ${returnBranch(context, listen: false).branches.length + 1}',
                name: nameController.text.trim(),
                projectId: widget.project.uuid!,
                level: 0,
                employees:
                    returnBranch(context, listen: false)
                        .selectedStaffs
                        .map((staf) => staf.id!)
                        .toList(),
                companyId:
                    CompanyProvider().currentCompany!.id!,
              ),
            );
          },
          nameController: nameController,
          descController: descController,
        );
      },
    );
  }

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
                                  InkWell(
                                    onTap: () {
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
                                    child: Text(
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: returnTheme(
                                          context,
                                        ).darkGrey(),
                                      ),
                                      widget.project.name,
                                    ),
                                  ),
                                  MainDivider(height: 10),
                                  SizedBox(height: 8),
                                  Text(
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
                                        title:
                                            calcPercentage(
                                              widget
                                                  .project
                                                  .level,
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
                                  SizedBox(height: 20),
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
                                            onTap: () {
                                              createBranch();
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
                                                      pro,
                                                    ) => Container(
                                                      margin: EdgeInsets.symmetric(
                                                        vertical:
                                                            3,
                                                      ),
                                                      padding: EdgeInsets.symmetric(
                                                        vertical:
                                                            15,
                                                        horizontal:
                                                            15,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: returnTheme(
                                                          context,
                                                        ).white(),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            pro.name,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            );
                                          } else {
                                            return EmptyWidgetMain(
                                              action: () =>
                                                  createBranch(),
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
          vertical: 20,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Column(
            spacing: 2,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                style: TextStyle(
                  fontSize: 9,
                  color: returnTheme(context).mediumGrey(),
                ),
                text,
              ),
              Text(
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

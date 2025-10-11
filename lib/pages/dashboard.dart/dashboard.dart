import 'package:flutter/material.dart';
import 'package:promas/components/alert_dialogues/add_project_dialog.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/empty_widgets/empty_widget_main.dart';
import 'package:promas/components/main_floating_action_button.dart';
import 'package:promas/components/tiles/project_tile.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/project_page.dart';
import 'package:promas/providers/branch_provider.dart';
import 'package:promas/providers/project_provider.dart';
import 'package:promas/providers/requests_provider.dart';
import 'package:promas/providers/user_provider.dart';

class Dashboard extends StatefulWidget {
  final TextEditingController projectSearchController;
  const Dashboard({
    super.key,
    required this.projectSearchController,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<void> createProject() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AddProjectDialog(
          descController: descController,
          nameController: nameController,
        );
      },
    );
  }

  final nameController = TextEditingController();
  final descController = TextEditingController();

  Future<void> getAllProjectss() async {
    await ProjectProvider().getAllProjectsByCompany();
  }

  Future<void> getAllBranches() async {
    await BranchProvider().getBranchesByCompany();
  }

  Future<void> getAllRequests() async {
    await RequestsProvider().getRequestsByCompany();
  }

  Future<void> getAllUsers() async {
    await UserProvider().getAllCompanyUsers();
  }

  Future<void> initFuncs() async {
    setState(() {
      isLoadingData = true;
    });
    await getAllUsers();
    await getAllProjectss();
    await getAllBranches();
    await getAllRequests();
  }

  bool isLoadingData = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initFuncs();
      setState(() {
        isLoadingData = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: returnProject(
          context,
        ).projectsMain.isNotEmpty,
        child: MainFloatingActionButton(
          action: () async {
            await createProject();
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          if (!returnRequest(
            context,
            listen: false,
          ).isLoaded) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
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
                          ).projects().isEmpty,
                          child: EmptyWidgetMain(
                            buttonText:
                                'Create New Project',
                            title:
                                'No Projects Created Yet',
                            action: () async {
                              await createProject();
                            },
                          ),
                        ),
                        Visibility(
                          visible: returnProject(
                            context,
                            listen: false,
                          ).projects().isNotEmpty,
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
                                                listen:
                                                    false,
                                              )
                                              .projects()
                                              .where(
                                                (pro) => pro
                                                    .name
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
                                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent:
                                              300,
                                          mainAxisExtent:
                                              130,
                                          // childAspectRatio:
                                          //     2,
                                          crossAxisSpacing:
                                              10,
                                          mainAxisSpacing:
                                              10,
                                        ),
                                        children:
                                            returnProject(
                                                  context,
                                                  listen:
                                                      false,
                                                )
                                                .projects()
                                                .where(
                                                  (
                                                    pro,
                                                  ) => pro
                                                      .name
                                                      .toLowerCase()
                                                      .contains(
                                                        widget.projectSearchController.text.toLowerCase(),
                                                      ),
                                                )
                                                .map(
                                                  (
                                                    project,
                                                  ) => ProjectTile(
                                                    viewProject: () async {
                                                      await returnProject(
                                                        context,
                                                        listen:
                                                            false,
                                                      ).deleteProject(
                                                        project.uuid!,
                                                      );
                                                    },
                                                    project:
                                                        project,
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          returnProject(
                                                context,
                                                listen:
                                                    false,
                                              )
                                              .projects()
                                              .where(
                                                (pro) => pro
                                                    .name
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
                                        height:
                                            double.infinity,
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
                                                  fontSize:
                                                      13,
                                                  color: returnTheme(
                                                    context,
                                                  ).darkMediumGrey(),
                                                ),
                                                'No Projects Found',
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
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
                                              SizedBox(
                                                height: 55,
                                              ),
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
                                        maxCrossAxisExtent:
                                            300,
                                        mainAxisExtent: 130,
                                        // childAspectRatio:
                                        //     2,
                                        crossAxisSpacing:
                                            10,
                                        mainAxisSpacing: 10,
                                      ),
                                  children: returnProject(context)
                                      .projects()
                                      .map(
                                        (
                                          pro,
                                        ) => ProjectTile(
                                          project: pro,
                                          viewProject: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ProjectPage(
                                                    project:
                                                        pro,
                                                  );
                                                },
                                              ),
                                            );
                                          },
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
            );
          }
        },
      ),
    );
  }
}

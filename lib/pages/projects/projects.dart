import 'package:flutter/material.dart';
import 'package:promas/components/alert_dialogues/add_project_dialog.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/empty_widgets/empty_widget_main.dart';
import 'package:promas/components/main_floating_action_button.dart';
import 'package:promas/components/tiles/project_tile.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/project_page.dart';
import 'package:promas/providers/branch_provider.dart';
import 'package:promas/providers/project_provider.dart';

class Projects extends StatefulWidget {
  final TextEditingController projectSearchController;
  const Projects({
    super.key,
    required this.projectSearchController,
  });

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  Future<void> createProject() async {
    showDialog(
      context: context,
      builder: (context) {
        return AddProjectDialog(
          descController: descController,
          nameController: nameController,
        );
      },
    );
  }

  int currentIndex = 0;
  void toggleCompleted({required int value}) {
    setState(() {
      currentIndex = value;
    });
  }

  final nameController = TextEditingController();
  final descController = TextEditingController();

  Future<void> getAllProjectss() async {
    await ProjectProvider().getAllProjectsByCompany();
  }

  Future<void> getAllBranches() async {
    await BranchProvider().getBranchesByCompany();
  }

  Future<void> initFuncs() async {
    await getAllProjectss();
    await getAllBranches();
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
      body: Column(
        spacing: 2,
        children: [
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color.fromARGB(
                    83,
                    141,
                    141,
                    141,
                  ),
                ),
              ),
            ),
            child: Row(
              spacing: 5,
              children: [
                SwitchTabButton(
                  title: 'Incomplete',
                  myIndex: 0,
                  currentIndex: currentIndex,
                  toggleCompleted: () {
                    toggleCompleted(value: 0);
                  },
                ),
                SwitchTabButton(
                  title: 'Completed',
                  myIndex: 1,
                  currentIndex: currentIndex,
                  toggleCompleted: () {
                    toggleCompleted(value: 1);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Stack(
              children: [
                Visibility(
                  visible: currentIndex == 0
                      ? returnProject(
                          context,
                        ).projectsMain.where((project) {
                          var branches =
                              returnBranch(
                                context,
                              ).branches.where(
                                (branch) =>
                                    branch.projectId ==
                                    project.uuid,
                              );

                          var value = branches
                              .map((bra) => bra.level)
                              .toList();
                          var perc = calcPercentageNumber(
                            value,
                          );
                          if (perc != 100) {
                            return true;
                          } else {
                            return false;
                          }
                        }).isEmpty
                      : currentIndex == 1
                      ? returnProject(
                          context,
                        ).projectsMain.where((project) {
                          var branches =
                              returnBranch(
                                context,
                              ).branches.where(
                                (branch) =>
                                    branch.projectId ==
                                    project.uuid,
                              );

                          var value = branches
                              .map((bra) => bra.level)
                              .toList();
                          var perc = calcPercentageNumber(
                            value,
                          );
                          if (perc == 100) {
                            return true;
                          } else {
                            return false;
                          }
                        }).isEmpty
                      : false,
                  child: EmptyWidgetMain(
                    buttonText: 'Create New Project',
                    title:
                        returnProject(
                          context,
                        ).projectsMain.isEmpty
                        ? 'No Projects Created Yet'
                        : returnProject(
                            context,
                          ).projectsMain.where((project) {
                            var branches =
                                returnBranch(
                                  context,
                                ).branches.where(
                                  (branch) =>
                                      branch.projectId ==
                                      project.uuid,
                                );

                            var value = branches
                                .map((bra) => bra.level)
                                .toList();
                            var perc = calcPercentageNumber(
                              value,
                            );
                            if (perc == 100) {
                              return true;
                            } else {
                              return false;
                            }
                          }).isEmpty
                        ? 'You Don\'t have any Completed Projects'
                        : 'You Don\'t have any Incompleted Projects',
                    action: () async {
                      await createProject();
                    },
                  ),
                ),
                Visibility(
                  visible: returnProject(
                    context,
                    listen: false,
                  ).projectsMain.isNotEmpty,
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
                                      ).projectsMain
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
                                      maxCrossAxisExtent:
                                          300,
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
                                        ).projectsMain
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
                                            viewProject: () async {
                                              await returnProject(
                                                context,
                                                listen:
                                                    false,
                                              ).deleteProject(
                                                project
                                                    .uuid!,
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
                                        listen: false,
                                      ).projectsMain
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
                        child: Stack(
                          children: [
                            Visibility(
                              visible: currentIndex == 0,
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                          300,
                                      mainAxisExtent: 130,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                children: returnProject(context)
                                    .projectsMain
                                    .where((project) {
                                      var branches =
                                          returnBranch(
                                            context,
                                          ).branches.where(
                                            (branch) =>
                                                branch
                                                    .projectId ==
                                                project
                                                    .uuid,
                                          );

                                      var value = branches
                                          .map(
                                            (bra) =>
                                                bra.level,
                                          )
                                          .toList();
                                      var perc =
                                          calcPercentageNumber(
                                            value,
                                          );
                                      if (perc != 100) {
                                        return true;
                                      } else {
                                        return false;
                                      }
                                    })
                                    .map(
                                      (pro) => ProjectTile(
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
                            Visibility(
                              visible: currentIndex == 1,
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                          300,
                                      mainAxisExtent: 130,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                children: returnProject(context)
                                    .projectsMain
                                    .where((project) {
                                      var branches =
                                          returnBranch(
                                            context,
                                          ).branches.where(
                                            (branch) =>
                                                branch
                                                    .projectId ==
                                                project
                                                    .uuid,
                                          );

                                      var value = branches
                                          .map(
                                            (bra) =>
                                                bra.level,
                                          )
                                          .toList();
                                      var perc =
                                          calcPercentageNumber(
                                            value,
                                          );
                                      if (perc == 100) {
                                        return true;
                                      } else {
                                        return false;
                                      }
                                    })
                                    .map(
                                      (pro) => ProjectTile(
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
          ),
        ],
      ),
    );
  }
}

class SwitchTabButton extends StatelessWidget {
  final int currentIndex;
  final Function() toggleCompleted;
  final int myIndex;
  final String title;
  const SwitchTabButton({
    super.key,
    required this.currentIndex,
    required this.toggleCompleted,
    required this.myIndex,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: toggleCompleted,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: currentIndex != myIndex
                    ? Colors.transparent
                    : returnTheme(context).tertiaryColor(),
                width: currentIndex != myIndex ? 0 : 2,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Center(
              child: Text(
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: returnTheme(
                    context,
                  ).darkMediumGrey(),
                ),
                title,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

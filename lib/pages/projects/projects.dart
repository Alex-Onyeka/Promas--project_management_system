import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/add_project_dialog.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/empty_widgets/empty_widget_main.dart';
import 'package:promas/components/main_floating_action_button.dart';
import 'package:promas/components/tiles/project_tile.dart';
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
          urlController: urlController,
        );
      },
    );
  }

  int currentIndex = 0;
  void toggleManaged({required int value}) {
    setState(() {
      currentIndex = value;
    });
  }

  final nameController = TextEditingController();
  final urlController = TextEditingController();
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
    List<ProjectClass> getProjectsForEmployee(
      BuildContext context,
    ) {
      final user = returnUser(
        context: context,
      ).currentUser!;
      final allProjects = returnProject(
        context: context,
      ).projectsMain;
      final allBranches = returnBranch(
        context: context,
      ).branches;

      final projectsIn = allProjects.where((proj) {
        final projectBranches = allBranches.where(
          (bran) => bran.projectId == proj.uuid,
        );

        return projectBranches.any(
          (bran) => bran.employees.contains(user.id),
        );
      }).toList();

      return projectsIn;
    }

    List<ProjectClass> projectIn =
        returnUser(context: context).currentUser!.isAdmin
        ? returnProject(context: context).projectsMain
        : getProjectsForEmployee(context);
    projectIn.sort(
      (a, b) => b.createdAt!.compareTo(a.createdAt!),
    );
    return Scaffold(
      floatingActionButton: Visibility(
        visible: projectIn.isNotEmpty,
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
                  title: 'Managed',
                  myIndex: 0,
                  currentIndex: currentIndex,
                  toggleManaged: () {
                    toggleManaged(value: 0);
                  },
                ),
                SwitchTabButton(
                  title: 'Unmanaged',
                  myIndex: 1,
                  currentIndex: currentIndex,
                  toggleManaged: () {
                    toggleManaged(value: 1);
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
                  visible: projectIn.isEmpty,
                  child: EmptyWidgetMain(
                    buttonText: ' Create New Project',
                    title: 'No Projects Created Yet',
                    action: () async {
                      await createProject();
                    },
                  ),
                ),
                Visibility(
                  visible: projectIn.isNotEmpty,
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
                              visible: projectIn
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
                              child: Column(
                                spacing: 5,
                                children: projectIn
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
                                          await returnProject()
                                              .deleteProject(
                                                project
                                                    .uuid!,
                                              );
                                        },
                                        project: project,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Visibility(
                              visible: projectIn
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
                                          context: context,
                                        ).darkGrey(),
                                        Icons
                                            .work_off_outlined,
                                      ),
                                      Text(
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: returnTheme(
                                            context:
                                                context,
                                          ).darkMediumGrey(),
                                        ),
                                        'No Projects Found Under this Name',
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
                              child: Stack(
                                children: [
                                  Visibility(
                                    visible: projectIn
                                        .where(
                                          (project) =>
                                              project
                                                  .githubUrl !=
                                              null,
                                        )
                                        .isNotEmpty,
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        await initFuncs();
                                      },
                                      backgroundColor:
                                          Colors.white,
                                      color: returnTheme()
                                          .tertiaryLight(),
                                      displacement: 10,
                                      child: ListView(
                                        children: projectIn
                                            .where(
                                              (project) =>
                                                  project
                                                      .githubUrl !=
                                                  null,
                                            )
                                            .map(
                                              (
                                                pro,
                                              ) => ProjectTile(
                                                project:
                                                    pro,
                                                viewProject: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) {
                                                            return ProjectPage(
                                                              project: pro,
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
                                  ),
                                  Visibility(
                                    visible: projectIn
                                        .where(
                                          (project) =>
                                              project
                                                  .githubUrl !=
                                              null,
                                        )
                                        .isEmpty,
                                    child: EmptyWidgetMain(
                                      buttonText:
                                          ' Create New Project',
                                      title:
                                          'You Don\'t have any Managed Projects',
                                      action: () async {
                                        await createProject();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: currentIndex == 1,
                              child: Stack(
                                children: [
                                  Visibility(
                                    visible: projectIn
                                        .where(
                                          (project) =>
                                              project
                                                  .githubUrl ==
                                              null,
                                        )
                                        .isNotEmpty,
                                    child: RefreshIndicator(
                                      onRefresh: () async {
                                        await initFuncs();
                                      },
                                      backgroundColor:
                                          Colors.white,
                                      color: returnTheme()
                                          .tertiaryLight(),
                                      displacement: 10,
                                      child: ListView(
                                        children: projectIn
                                            .where(
                                              (project) =>
                                                  project
                                                      .githubUrl ==
                                                  null,
                                            )
                                            .map(
                                              (
                                                pro,
                                              ) => ProjectTile(
                                                project:
                                                    pro,
                                                viewProject: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) {
                                                            return ProjectPage(
                                                              project: pro,
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
                                  ),
                                  Visibility(
                                    visible: projectIn
                                        .where(
                                          (project) =>
                                              project
                                                  .githubUrl ==
                                              null,
                                        )
                                        .isEmpty,
                                    child: EmptyWidgetMain(
                                      buttonText:
                                          ' Create New Project',
                                      title:
                                          'You Don\'t have any Unmanaged Projects',
                                      action: () async {
                                        await createProject();
                                      },
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
          ),
        ],
      ),
    );
  }
}

class SwitchTabButton extends StatelessWidget {
  final int currentIndex;
  final Function() toggleManaged;
  final int myIndex;
  final String title;
  const SwitchTabButton({
    super.key,
    required this.currentIndex,
    required this.toggleManaged,
    required this.myIndex,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: toggleManaged,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: currentIndex != myIndex
                    ? Colors.transparent
                    : returnTheme(
                        context: context,
                      ).tertiaryColor(),
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
                    context: context,
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

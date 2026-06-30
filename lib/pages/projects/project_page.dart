import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/add_branch_dialog.dart';
import 'package:promas/components/alert_dialogues/add_project_dialog.dart';
import 'package:promas/components/alert_dialogues/delete_project_dialog.dart';
import 'package:promas/components/empty_widgets/empty_widget_alt.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/side_bar/right_side_bar.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/components/top_bar/mobile_app_bar.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/branch_page/branch_page.dart';
import 'package:promas/pages/projects/components/branch_list_tile.dart';
import 'package:promas/pages/projects/components/github_instruction_widget.dart';

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
  final urlController = TextEditingController();
  bool isLoading = false;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
    print('Loading is now $isLoading');
  }

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    List<BranchClass> branchIn =
        returnBranch(context: context).branches
            .where(
              (bra) => bra.projectId == widget.project.uuid,
            )
            .toList();
    branchIn.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      key: _scaffoldKey,
      appBar: screenSize(context) > mobileScreen
          ? null
          : appBar(context: context, isMain: false),
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
                    isMain: false,
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
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: theme.white(),
                          ),
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
                                      Material(
                                        color: Colors
                                            .transparent,
                                        child: InkWell(
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
                                              color: returnTheme(
                                                context:
                                                    context,
                                              ).darkGrey(),
                                              Icons
                                                  .arrow_back_ios_new_rounded,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign
                                            .center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              returnTheme(
                                                context:
                                                    context,
                                              ).darkGrey(),
                                        ),
                                        widget.project.name,
                                      ),
                                      Opacity(
                                        opacity:
                                            widget
                                                    .project
                                                    .githubUrl !=
                                                null
                                            ? 1
                                            : 0,
                                        child:
                                            GithubInstructionWidget(
                                              project: widget
                                                  .project,
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
                                        context: context,
                                      ).darkMediumGrey(),
                                    ),
                                    widget.project.desc,
                                  ),
                                  SizedBox(height: 25),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                    decoration: BoxDecoration(
                                      color:
                                          theme.isDarkMode
                                          ? theme
                                                .containerColor()
                                          : Colors
                                                .grey
                                                .shade100,
                                    ),
                                    child: Row(
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
                                              Visibility(
                                                visible: returnUser(
                                                  context:
                                                      context,
                                                ).currentUser!.isAdmin,
                                                child: Material(
                                                  color: Colors
                                                      .transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context:
                                                            context,
                                                        builder:
                                                            (
                                                              context,
                                                            ) {
                                                              return AddProjectDialog(
                                                                project: widget.project,
                                                                nameController: nameController,
                                                                descController: descController,
                                                                urlController: urlController,
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
                                                            size: 18,
                                                            color: returnTheme(
                                                              context: context,
                                                            ).mediumGrey(),
                                                            Icons.edit_outlined,
                                                          ),
                                                          Text(
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: returnTheme(
                                                                context: context,
                                                              ).mediumGrey(),
                                                            ),
                                                            'Edit',
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
                                                    openChatPage(
                                                      context:
                                                          context,
                                                      id:
                                                          widget.project.uuid ??
                                                          '',
                                                      index:
                                                          3,
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
                                                          size: 18,
                                                          color: returnTheme(
                                                            context: context,
                                                          ).mediumGrey(),
                                                          Icons.chat,
                                                        ),
                                                        Text(
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: returnTheme(
                                                              context: context,
                                                            ).mediumGrey(),
                                                          ),
                                                          'Chat',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: returnUser(
                                                  context:
                                                      context,
                                                ).currentUser!.isAdmin,
                                                child: Material(
                                                  color: Colors
                                                      .transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context:
                                                            context,
                                                        builder:
                                                            (
                                                              context,
                                                            ) {
                                                              return DeleteProjectDialog(
                                                                project: widget.project,
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
                                                            MainAxisSize.min,
                                                        spacing:
                                                            5,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            size: 18,
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
                                                              fontSize: 11,
                                                              color: const Color.fromARGB(
                                                                255,
                                                                255,
                                                                92,
                                                                92,
                                                              ),
                                                            ),
                                                            'Delete',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                                          Text(
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              color: returnTheme(
                                                context:
                                                    context,
                                              ).darkGrey(),
                                            ),
                                            'BRANCHES',
                                          ),
                                          IgnorePointer(
                                            ignoring: !returnUser(
                                              context:
                                                  context,
                                            ).currentUser!.isAdmin,
                                            child: Material(
                                              color: Colors
                                                  .transparent,
                                              child: InkWell(
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
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        10,
                                                    horizontal:
                                                        10,
                                                  ),
                                                  child: Row(
                                                    spacing:
                                                        3,
                                                    children: [
                                                      Icon(
                                                        color: returnTheme(
                                                          context: context,
                                                        ).darkMediumGrey(),
                                                        size:
                                                            18,
                                                        Icons.add,
                                                      ),
                                                      Text(
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: returnTheme(
                                                            context: context,
                                                          ).darkMediumGrey(),
                                                        ),
                                                        'Create New Branch',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (branchIn
                                              .isNotEmpty) {
                                            return Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Column(
                                                  spacing:
                                                      10,
                                                  children: branchIn
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
                                                          projectId: widget.project.uuid!,
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

// class DashboardContainers extends StatelessWidget {
//   const DashboardContainers({
//     super.key,
//     required this.title,
//     required this.text,
//   });

//   final String? title;
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           vertical: 10,
//           horizontal: 5,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: const Color.fromARGB(36, 33, 33, 33),
//           ),
//           borderRadius: mainBorderRadius,
//         ),
//         child: Center(
//           child: Column(
//             spacing: 2,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 9,
//                   color: returnTheme(
//                     context: context,
//                   ).mediumGrey(),
//                 ),
//                 text,
//               ),
//               Text(
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                   color: returnTheme(
//                     context: context,
//                   ).darkMediumGrey(),
//                 ),
//                 title ?? 'Not Set',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
        projectId: projectId,
        branch: branch,
        nameController: nameController,
        descController: descController,
      );
    },
  ).then((_) {
    returnBranch().clearSelectedStaffs();
  });
}

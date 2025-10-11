import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class ProjectTile extends StatelessWidget {
  final ProjectClass project;
  final Function() viewProject;
  const ProjectTile({
    super.key,
    required this.project,
    required this.viewProject,
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
            onTap: viewProject,
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
                                  left: 10.0,
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
                                spacing: 4,
                                children: [
                                  Row(
                                    spacing: 3,
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
                                        'Level:',
                                      ),
                                      Text(
                                        style: TextStyle(
                                          fontSize:
                                              screen >
                                                  mobileScreen
                                              ? 9
                                              : 7,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color: theme
                                              .darkMediumGrey(),
                                        ),
                                        calcPercentage(
                                          returnBranch(
                                                context,
                                              ).branches
                                              .where(
                                                (branch) =>
                                                    branch
                                                        .projectId ==
                                                    project
                                                        .uuid,
                                              )
                                              .toList()
                                              .map(
                                                (
                                                  branch,
                                                ) => branch
                                                    .level,
                                              )
                                              .toList(),
                                        ),
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
                                    spacing: 3,
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
                                              ? 9
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

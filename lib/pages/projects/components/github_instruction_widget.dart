import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class GithubInstructionWidget extends StatelessWidget {
  final ProjectClass project;
  const GithubInstructionWidget({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (firsContext) {
              return AlertPlaceholder(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Text(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.darkMediumGrey(),
                      ),
                      'Github Instructions',
                    ),
                    Container(
                      height: 2,
                      width: 300,
                      decoration: BoxDecoration(
                        color: theme.lightMediumGrey(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          3,
                        ),
                        border: Border.all(
                          color: theme.isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade400,
                        ),
                        color: theme.isDarkMode
                            ? theme.containerColor()
                            : Colors.grey.shade200,
                      ),
                      child: Column(
                        spacing: 15,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            // spacing: 5,
                            children: [
                              Text(
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: theme
                                      .darkMediumGrey(),
                                ),
                                'Push Url:',
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight
                                                .normal,
                                        color: theme
                                            .lightMediumGrey(),
                                      ),
                                      '${project.githubUrl}.git',
                                    ),
                                  ),
                                  Material(
                                    color:
                                        Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        copyToClipboard(
                                          context,
                                          '${project.githubUrl}.git',
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(
                                              4.0,
                                            ),
                                        child: Icon(
                                          size: 18,
                                          color: theme
                                              .lightMediumGrey(),
                                          Icons.copy,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            // width: 200,
                            height: 1,
                            color: theme.isDarkMode
                                ? Colors.grey.shade900
                                : Colors.grey.shade400,
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            // spacing: 5,
                            children: [
                              Text(
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: theme
                                      .darkMediumGrey(),
                                ),
                                'Clone Url:',
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight
                                                .normal,
                                        color: theme
                                            .lightMediumGrey(),
                                      ),
                                      '${project.githubUrl}.git',
                                    ),
                                  ),
                                  Material(
                                    color:
                                        Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        copyToClipboard(
                                          context,
                                          '${project.githubUrl}.git',
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(
                                              4.0,
                                            ),
                                        child: Icon(
                                          size: 18,
                                          color: theme
                                              .lightMediumGrey(),
                                          Icons.copy,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                        Text(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.darkMediumGrey(),
                          ),
                          'NOTE: To Colaborate On This Project;',
                        ),
                        SizedBox(height: 5),
                        GithubSetUpStepsWidget(
                          title:
                              'You must first set your Profile Alias (email).',
                        ),
                        GithubSetUpStepsWidget(
                          title:
                              'Then update your GitHub email locally using: (git config --global user.email "your-email@example.com").',
                        ),
                        GithubSetUpStepsWidget(
                          title:
                              'Next, ensure your GitHub account email matches this Profile Alias.',
                        ),
                        GithubSetUpStepsWidget(
                          title:
                              'After that, accept the collaboration invitation sent by the project owner on GitHub.',
                        ),
                        GithubSetUpStepsWidget(
                          title:
                              'Once these steps are completed, you can clone the repository to your local machine, begin working, and push your changes when ready.',
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            size: 24,
            color: returnTheme(context: context).darkGrey(),
            Icons.menu_open_sharp,
          ),
        ),
      ),
    );
  }
}

class GithubSetUpStepsWidget extends StatelessWidget {
  const GithubSetUpStepsWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          color: theme.lightMediumGrey(),
          Icons.arrow_right,
        ),
        Expanded(
          child: Text(
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: theme.lightMediumGrey(),
            ),
            title,
          ),
        ),
      ],
    );
  }
}

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
    var theme = returnTheme(context: context);
    var screen = screenSize(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: mainBorderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(5, 0, 0, 0),
            blurRadius: 10,
            spreadRadius: 10,
          ),
        ],
        color: returnTheme(context: context).white(),
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: mainBorderRadius,
            color: returnTheme(context: context).white(),
          ),
          child: InkWell(
            borderRadius: mainBorderRadius,
            onTap: viewProject,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Row(
                spacing: 5,
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
                      size: 18,
                      color: theme.darkMediumGrey(),
                      Icons.workspace_premium_rounded,
                    ),
                  ),
                  SizedBox(
                    width: screen > mobileScreen ? 10 : 8,
                  ),
                  Expanded(
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
                  Icon(
                    size: 18,
                    color: theme.lightMediumGrey(),
                    Icons.arrow_forward_ios_rounded,
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

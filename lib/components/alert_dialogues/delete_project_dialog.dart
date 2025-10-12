import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/main.dart';

class DeleteProjectDialog extends StatefulWidget {
  final ProjectClass project;
  const DeleteProjectDialog({
    super.key,
    required this.project,
  });

  @override
  State<DeleteProjectDialog> createState() =>
      _DeleteProjectDialogState();
}

class _DeleteProjectDialogState
    extends State<DeleteProjectDialog> {
  bool isLoading = false;

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertPlaceholder(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            HeadingSection(
              title: 'Delete Project',
              subText:
                  'Are you sure you want to delete this project?',
            ),
            SizedBox(height: 10),
            MainButton(
              action: () async {
                toggleLoading(true);
                await returnProject(
                  context,
                  listen: false,
                ).deleteProject(widget.project.uuid!);
                toggleLoading(false);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              title: 'Delete Project',
              loadingWidget: isLoading,
            ),
            SizedBox(height: 4),
            SecondaryButton(
              title: 'Cancel',
              action: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/main.dart';

class DeleteBranchDialog extends StatefulWidget {
  final BranchClass branch;
  const DeleteBranchDialog({
    super.key,
    required this.branch,
  });

  @override
  State<DeleteBranchDialog> createState() =>
      _DeleteBranchDialogState();
}

class _DeleteBranchDialogState
    extends State<DeleteBranchDialog> {
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
              title: 'Delete Branch',
              subText:
                  'Are you sure you want to Remove this Branch From Project?',
            ),
            SizedBox(height: 10),
            MainButton(
              action: () async {
                toggleLoading(true);
                await returnBranch(
                  context,
                  listen: false,
                ).deleteBranch(widget.branch.uuid!);
                toggleLoading(false);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              title: 'Delete Branch',
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

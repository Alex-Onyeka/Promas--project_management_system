import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/main.dart';

class RemoveStaffDialog extends StatefulWidget {
  final BranchClass branch;
  final UserClass user;
  const RemoveStaffDialog({
    super.key,
    required this.branch,
    required this.user,
  });

  @override
  State<RemoveStaffDialog> createState() =>
      _RemoveStaffDialogState();
}

class _RemoveStaffDialogState
    extends State<RemoveStaffDialog> {
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
              title: 'Remove Staff',
              subText:
                  'Are you sure you want to remove this staff from the Branch?',
            ),
            SizedBox(height: 10),
            MainButton(
              action: () async {
                toggleLoading(true);
                await returnBranch(
                  context,
                  listen: false,
                ).removeStaffFromBranch(
                  widget.branch.uuid!,
                  widget.user.id!,
                );
                toggleLoading(false);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              title: 'Remove Staff',
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

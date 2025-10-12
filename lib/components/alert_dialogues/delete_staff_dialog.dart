import 'package:flutter/material.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/providers/user_provider.dart';

class DeleteStaffDialog extends StatefulWidget {
  final UserClass user;
  const DeleteStaffDialog({super.key, required this.user});

  @override
  State<DeleteStaffDialog> createState() =>
      _DeleteStaffDialogState();
}

class _DeleteStaffDialogState
    extends State<DeleteStaffDialog> {
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
              title: 'Delete Staff',
              subText:
                  'Are you sure you want to Remove this Staff From Company?',
            ),
            SizedBox(height: 10),
            MainButton(
              action: () async {
                toggleLoading(true);
                await UserProvider().removeUserFromCompany(
                  widget.user.id!,
                );
                toggleLoading(false);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              title: 'Delete Staff',
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

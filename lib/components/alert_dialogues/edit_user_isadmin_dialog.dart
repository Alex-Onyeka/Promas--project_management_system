import 'package:flutter/material.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/providers/user_provider.dart';

class EditUserIsAdminDialog extends StatefulWidget {
  final UserClass user;
  final bool boolValue;
  const EditUserIsAdminDialog({
    super.key,
    required this.user,
    required this.boolValue,
  });

  @override
  State<EditUserIsAdminDialog> createState() =>
      EditUserIsAdminDialogState();
}

class EditUserIsAdminDialogState
    extends State<EditUserIsAdminDialog> {
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
              title: 'Make Admin',
              subText:
                  'Are you sure you want to make this staff an Admin?',
            ),
            SizedBox(height: 10),
            MainButton(
              action: () async {
                toggleLoading(true);
                await UserProvider().editUserIdAdmin(
                  widget.user.id!,
                  widget.boolValue,
                );
                toggleLoading(false);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              title: 'Make Staff Admin?',
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

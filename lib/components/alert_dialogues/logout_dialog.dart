import 'package:flutter/material.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/pages/base_page.dart';
import 'package:promas/services/auth_service.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
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
              title: 'Logout',
              subText:
                  'You are about to logout from your account, Are you sure you want to proceed?',
            ),
            SizedBox(height: 10),
            MainButton(
              action: () async {
                toggleLoading(true);
                await AuthService().signOut(
                  context: context,
                );
                toggleLoading(false);
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BasePage();
                      },
                    ),
                  );
                }
              },
              title: 'Log out',
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

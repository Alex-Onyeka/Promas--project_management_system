import 'package:flutter/material.dart';
import 'package:promas/classes/request_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/providers/requests_provider.dart';

class DeclineRequestDialog extends StatefulWidget {
  final RequestClass request;
  const DeclineRequestDialog({
    super.key,
    required this.request,
  });

  @override
  State<DeclineRequestDialog> createState() =>
      DeclineRequestDialogState();
}

class DeclineRequestDialogState
    extends State<DeclineRequestDialog> {
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
              title: 'Decline Request',
              subText:
                  'Are you sure you want to decline this request?',
            ),
            SizedBox(height: 10),
            MainButton(
              action: () async {
                toggleLoading(true);
                await RequestsProvider().deleteRequest(
                  widget.request.userId!,
                );
                toggleLoading(false);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              title: 'Decline Request',
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

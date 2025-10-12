import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/main.dart';

class UpdateLevelDialog extends StatefulWidget {
  final Function() updateBranch;
  final BranchClass branch;
  // final bool isLoading;
  const UpdateLevelDialog({
    super.key,
    required this.updateBranch,
    required this.branch,
    // required this.isLoading
  });

  @override
  State<UpdateLevelDialog> createState() =>
      _UpdateLevelDialogState();
}

class _UpdateLevelDialogState
    extends State<UpdateLevelDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        level = widget.branch.level;
      });
    });
  }

  double level = 0;
  void updateLevel(double newL) {
    setState(() {
      level = newL;
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertPlaceholder(
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              HeadingSection(
                title: 'Update Branch Level',
                subText:
                    'Select a Percentage to update Branch Level',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Text(
                      style: TextStyle(
                        fontSize: 10,
                        color: returnTheme(
                          context,
                        ).mediumGrey(),
                      ),
                      'Current Branch Level',
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      spacing: 4,
                      children: [
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(0);
                          },
                          level: level,
                          percentage: 0,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(10);
                          },
                          level: level,
                          percentage: 10,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(20);
                          },
                          level: level,
                          percentage: 20,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(30);
                          },
                          level: level,
                          percentage: 30,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(40);
                          },
                          level: level,
                          percentage: 40,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(50);
                          },
                          level: level,
                          percentage: 50,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(60);
                          },
                          level: level,
                          percentage: 60,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(70);
                          },
                          level: level,
                          percentage: 70,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(80);
                          },
                          level: level,
                          percentage: 80,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(90);
                          },
                          level: level,
                          percentage: 90,
                        ),
                        BranchPercentageSelectionContainer(
                          branch: widget.branch,
                          action: () {
                            updateLevel(100);
                          },
                          level: level,
                          percentage: 100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              MainButton(
                loadingWidget: isLoading,
                action: () async {
                  setState(() {
                    isLoading = true;
                  });
                  widget.branch.level = level;
                  await returnBranch(
                    context,
                    listen: false,
                  ).updateBranch(
                    widget.branch.uuid!,
                    widget.branch,
                  );
                  widget.updateBranch();
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).pop();
                },
                title: 'Update Branch Level',
              ),
              SizedBox(height: 4),
              SecondaryButton(
                title: 'Cancel',
                action: () {
                  returnBranch(
                    context,
                    listen: false,
                  ).clearSelectedStaffs();
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class BranchPercentageSelectionContainer
    extends StatelessWidget {
  const BranchPercentageSelectionContainer({
    super.key,
    required this.branch,
    required this.percentage,
    required this.action,
    required this.level,
  });

  final BranchClass branch;
  final double percentage;
  final Function() action;
  final double level;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: action,
        child: Column(
          spacing: 2,
          children: [
            SizedBox(height: 2),
            Text(
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: returnTheme(context).mediumGrey(),
              ),
              '$percentage%',
            ),
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: returnTheme(context).mediumGrey(),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(4.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: level >= percentage
                      ? returnTheme(context).tertiaryLight()
                      : Colors.transparent,
                ),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

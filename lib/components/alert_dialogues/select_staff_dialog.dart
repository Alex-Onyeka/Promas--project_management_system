import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/main.dart';

class SelectStaffDialog extends StatefulWidget {
  final Function() selectStaff;
  final BranchClass? branch;
  final String projectId;
  const SelectStaffDialog({
    super.key,
    required this.selectStaff,
    required this.projectId,
    this.branch,
  });

  @override
  State<SelectStaffDialog> createState() =>
      _SelectStaffDialogState();
}

class _SelectStaffDialogState
    extends State<SelectStaffDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  final TextEditingController nameController =
      TextEditingController();

  // List<UserClass> users = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final tempUsers = returnUser(context: context).users
        .where(
          (user) => !returnBranch().branches
              .where(
                (br) =>
                    br.projectId ==
                    widget.branch?.projectId,
              )
              .any((br) => br.employees.contains(user.id)),
        )
        .toList();
    return AlertPlaceholder(
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              HeadingSection(
                title: 'Select Staff',
                subText:
                    'Select a staff to add to your Project Branch',
              ),
              SizedBox(height: 10),
              NormalTextfield(
                showTitle: false,
                inputController: nameController,
                hintText: 'Search for Staff Name',
                title: 'Staff Name',
                isOptional: true,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 3),
              Builder(
                builder: (context) {
                  if (tempUsers.isEmpty) {
                    return Column(
                      children: [
                        Icon(
                          size: 20,
                          color: returnTheme(
                            context: context,
                          ).darkMediumGrey(),
                          Icons.person_outline_rounded,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                                vertical: 2.0,
                              ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                style: TextStyle(
                                  fontSize: 10,
                                  color: returnTheme(
                                    context: context,
                                  ).darkMediumGrey(),
                                ),
                                'You Haven\'t added any Staff to your Company',
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      spacing: 5,
                      children: tempUsers
                          .where(
                            (us) => us.name
                                .toLowerCase()
                                .contains(
                                  nameController.text
                                      .toLowerCase(),
                                ),
                          )
                          .map(
                            (user) => ListTile(
                              onTap: () {
                                if (!returnBranch()
                                    .selectedStaffs
                                    .contains(user)) {
                                  setState(() {
                                    returnBranch()
                                        .selectNewStaff(
                                          user,
                                        );
                                  });
                                  print(
                                    returnBranch()
                                        .selectedStaffs
                                        .length,
                                  );
                                  print(user.name);
                                } else {
                                  setState(() {
                                    returnBranch()
                                        .removeSelectedStaff(
                                          user,
                                        );
                                  });
                                  print(
                                    returnBranch()
                                        .selectedStaffs
                                        .length,
                                  );
                                }
                              },
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Text(
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: returnTheme(
                                        context: context,
                                      ).darkMediumGrey(),
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                    user.name,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(
                                      3,
                                    ),
                                    decoration: BoxDecoration(
                                      shape:
                                          BoxShape.circle,
                                      border: Border.all(
                                        color: returnTheme(
                                          context: context,
                                        ).mediumGrey(),
                                      ),
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(
                                            4.5,
                                          ),
                                      decoration: BoxDecoration(
                                        shape:
                                            BoxShape.circle,
                                        color:
                                            returnBranch()
                                                .selectedStaffs
                                                .contains(
                                                  user,
                                                )
                                            ? returnTheme(
                                                context:
                                                    context,
                                              ).tertiaryLight()
                                            : Colors
                                                  .transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
              SizedBox(height: 6),
              MainButton(
                loadingWidget: isLoading,
                action: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (returnBranch()
                      .selectedStaffs
                      .isNotEmpty) {
                    if (widget.branch != null) {
                      await returnBranch().addStaffToBranch(
                        widget.branch!.uuid!,
                        returnBranch().selectedStaffs
                            .map((staff) => staff.id!)
                            .toList(),
                      );
                      returnBranch().clearSelectedStaffs();
                    }
                    nameController.clear();
                    Navigator.of(context).pop();
                  }
                },
                title: 'Select Staff',
              ),
              SizedBox(height: 4),
              SecondaryButton(
                title: 'Cancel',
                action: () {
                  nameController.clear();
                  returnBranch().clearSelectedStaffs();
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

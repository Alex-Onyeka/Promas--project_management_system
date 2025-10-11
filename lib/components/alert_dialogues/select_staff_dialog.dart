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
  const SelectStaffDialog({
    super.key,
    required this.selectStaff,
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
                  if (returnUser(context).users.isEmpty) {
                    return Column(
                      children: [
                        Icon(
                          size: 20,
                          color: returnTheme(
                            context,
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
                                    context,
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
                      children: returnUser(context).users
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
                                if (!returnBranch(
                                  context,
                                  listen: false,
                                ).selectedStaffs.contains(
                                  user,
                                )) {
                                  setState(() {
                                    returnBranch(
                                      context,
                                      listen: false,
                                    ).selectNewStaff(user);
                                  });
                                  print(
                                    returnBranch(
                                      context,
                                      listen: false,
                                    ).selectedStaffs.length,
                                  );
                                  print(user.name);
                                } else {
                                  setState(() {
                                    returnBranch(
                                      context,
                                      listen: false,
                                    ).removeSelectedStaff(
                                      user,
                                    );
                                  });
                                  print(
                                    returnBranch(
                                      context,
                                      listen: false,
                                    ).selectedStaffs.length,
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
                                        context,
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
                                          context,
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
                                            returnBranch(
                                                  context,
                                                  listen:
                                                      false,
                                                )
                                                .selectedStaffs
                                                .contains(
                                                  user,
                                                )
                                            ? returnTheme(
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
                action: () {
                  if (returnBranch(
                    context,
                    listen: false,
                  ).selectedStaffs.isNotEmpty) {
                    if (widget.branch != null) {
                      returnBranch(
                        context,
                        listen: false,
                      ).addStaffToBranch(
                        widget.branch!,
                        returnBranch(context, listen: false)
                            .selectedStaffs
                            .map((staff) => staff.id!)
                            .toList(),
                      );
                      returnBranch(
                        context,
                        listen: false,
                      ).clearSelectedStaffs();
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

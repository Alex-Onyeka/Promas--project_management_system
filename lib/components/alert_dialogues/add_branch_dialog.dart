import 'package:flutter/material.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/alert_dialogues/select_staff_dialog.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/main.dart';

class AddBranchDialog extends StatefulWidget {
  final Function() addBranch;
  final TextEditingController nameController;
  final TextEditingController descController;
  const AddBranchDialog({
    super.key,
    required this.addBranch,
    required this.nameController,
    required this.descController,
  });

  @override
  State<AddBranchDialog> createState() =>
      _AddBranchDialogState();
}

class _AddBranchDialogState extends State<AddBranchDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var branchPr = returnBranch(context);
    return AlertPlaceholder(
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              HeadingSection(
                title: 'Create New Branch',
                subText:
                    'Fill The Form To Create New Branch',
              ),
              SizedBox(height: 10),
              NormalTextfield(
                inputController: widget.nameController,
                hintText: 'Enter Branch Name',
                title: 'Branch Name',
                isOptional: false,
              ),
              SizedBox(height: 3),
              NormalTextfield(
                inputController: widget.descController,
                hintText: 'Enter Branch Description',
                title: 'Branch Description',
                isOptional: true,
                numberOfLines: 3,
              ),
              SizedBox(height: 10),
              Builder(
                builder: (context) {
                  if (branchPr.selectedStaffs.isEmpty) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SelectStaffDialog(
                                selectStaff: () {},
                              );
                            },
                          );
                        },
                        child: Column(
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
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Text(
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: returnTheme(
                                        context,
                                      ).darkMediumGrey(),
                                    ),
                                    'No Staff Selected',
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    size: 15,
                                    color: returnTheme(
                                      context,
                                    ).secondaryColor(),
                                    Icons.add,
                                  ),
                                  Text(
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: returnTheme(
                                        context,
                                      ).secondaryColor(),
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                    'Add Staff',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Column(
                          spacing: 5,
                          children: returnBranch(context)
                              .selectedStaffs
                              .map(
                                (user) => ListTile(
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
                                              FontWeight
                                                  .bold,
                                        ),
                                        user.name,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          returnBranch(
                                            context,
                                            listen: false,
                                          ).removeSelectedStaff(
                                            user,
                                          );
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.all(
                                                3,
                                              ),
                                          decoration:
                                              BoxDecoration(
                                                shape: BoxShape
                                                    .circle,
                                              ),
                                          child: Icon(
                                            size: 20,
                                            color:
                                                returnTheme(
                                                  context,
                                                ).darkGrey(),
                                            Icons.clear,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 5),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder:
                                        (
                                          context,
                                          setState,
                                        ) {
                                          return SelectStaffDialog(
                                            selectStaff:
                                                () {},
                                          );
                                        },
                                  );
                                },
                              ).then((_) {
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Icon(
                                    size: 15,
                                    color: returnTheme(
                                      context,
                                    ).secondaryColor(),
                                    Icons.add,
                                  ),
                                  Text(
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: returnTheme(
                                        context,
                                      ).secondaryColor(),
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                    'Add Staff',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 10),
              MainButton(
                action: () {
                  if (_formKey.currentState!.validate()) {
                    widget.addBranch();
                    widget.nameController.clear();
                    widget.descController.clear();
                    Navigator.of(context).pop();
                  }
                },
                title: 'Create Branch',
              ),
              SizedBox(height: 4),
              SecondaryButton(
                title: 'Cancel',
                action: () {
                  widget.nameController.clear();
                  widget.descController.clear();
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

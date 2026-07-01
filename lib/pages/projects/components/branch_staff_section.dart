import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/components/alert_dialogues/remove_staff_dialog.dart';
import 'package:promas/components/alert_dialogues/select_staff_dialog.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/branch_page/branch_page.dart';
import 'package:promas/providers/chats_provider.dart';
import 'package:promas/providers/user_provider.dart';

class BranchStaffSection extends StatefulWidget {
  final BranchClass branch;
  const BranchStaffSection({
    super.key,
    required this.branch,
  });

  @override
  State<BranchStaffSection> createState() =>
      _BranchStaffSectionState();
}

class _BranchStaffSectionState
    extends State<BranchStaffSection> {
  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.white(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(20, 0, 0, 0),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Visibility(
            visible: returnUser(context: context).users
                .where(
                  (user) => widget.branch.employees
                      .contains(user.id),
                )
                .toList()
                .isNotEmpty,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  style: TextStyle(
                    fontSize: 11,
                    color: returnTheme(
                      context: context,
                    ).darkMediumGrey(),
                  ),
                  'Active Staffs:',
                ),
                Visibility(
                  visible: returnUser(
                    context: context,
                  ).currentUser!.isProjectManager(),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return SelectStaffDialog(
                                projectId:
                                    widget.branch.projectId,
                                branch: widget.branch,
                                selectStaff: () {},
                              );
                            },
                          );
                        },
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        spacing: 4,
                        children: [
                          Text(
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.secondaryLight(),
                            ),
                            'Add Staff',
                          ),
                          Icon(
                            size: 13,
                            color: theme.secondaryLight(),
                            Icons.add,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // MainDivider(height: 15),
          SizedBox(height: 10),
          Builder(
            builder: (context) {
              if (returnUser(context: context).users
                  .where(
                    (user) => widget.branch.employees
                        .contains(user.id),
                  )
                  .toList()
                  .isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 3,
                    children: [
                      Icon(
                        size: 15,
                        color: returnTheme(
                          context: context,
                        ).mediumGrey(),
                        Icons.person,
                      ),
                      Text(
                        style: TextStyle(
                          fontSize: 11,
                          color: returnTheme(
                            context: context,
                          ).darkGrey(),
                        ),
                        'No Staff Added to this Project',
                      ),
                      IgnorePointer(
                        ignoring: !returnUser(
                          context: context,
                        ).currentUser!.isProjectManager(),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return SelectStaffDialog(
                                      projectId: widget
                                          .branch
                                          .projectId,
                                      branch: widget.branch,
                                      selectStaff: () {},
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
                                  vertical: 3.0,
                                  horizontal: 10,
                                ),
                            child: Row(
                              spacing: 5,
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  size: 15,
                                  color: returnTheme(
                                    context: context,
                                  ).secondaryColor(),
                                  Icons.add,
                                ),
                                Text(
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: returnTheme(
                                      context: context,
                                    ).secondaryColor(),
                                  ),
                                  'Add Staff',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    spacing: 5,
                    children: returnUser(context: context)
                        .users
                        .where(
                          (user) => widget.branch.employees
                              .contains(user.id),
                        )
                        .toList()
                        .map(
                          (use) => Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color:
                                      const Color.fromARGB(
                                        31,
                                        66,
                                        66,
                                        66,
                                      ),
                                ),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                              spacing: 5,
                              children: [
                                Expanded(
                                  child: Row(
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        size: 15,
                                        color: returnTheme(
                                          context: context,
                                        ).mediumGrey(),
                                        Icons.person,
                                      ),
                                      Expanded(
                                        child: Text(
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: returnTheme(
                                              context:
                                                  context,
                                            ).darkGrey(),
                                          ),
                                          use.name,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      use.id !=
                                      returnUser()
                                          .currentUser
                                          ?.id,
                                  child: Material(
                                    color:
                                        Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        openChatPage(
                                          context: context,
                                          branchId: null,
                                          projectId: null,
                                          chatId: chatId(
                                            user1: returnUser()
                                                .currentUser!
                                                .id!,
                                            user2: use.id!,
                                          ),
                                          index: 1,
                                        );
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(
                                              8,
                                            ),
                                        decoration:
                                            BoxDecoration(
                                              shape: BoxShape
                                                  .circle,
                                            ),
                                        child: Icon(
                                          size: 18,
                                          color: returnTheme(
                                            context:
                                                context,
                                          ).secondaryLight(),
                                          Icons.chat,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      UserProvider()
                                          .currentUser!
                                          .isProjectManager() ==
                                      true,
                                  child: Material(
                                    color:
                                        Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return RemoveStaffDialog(
                                              branch: widget
                                                  .branch,
                                              user: use,
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(
                                              8,
                                            ),
                                        decoration:
                                            BoxDecoration(
                                              shape: BoxShape
                                                  .circle,
                                            ),
                                        child: Icon(
                                          size: 18,
                                          color: returnTheme(
                                            context:
                                                context,
                                          ).mediumGrey(),
                                          Icons.clear,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

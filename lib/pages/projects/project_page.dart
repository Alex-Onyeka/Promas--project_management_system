import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/classes/chats.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/add_branch_dialog.dart';
import 'package:promas/components/alert_dialogues/add_project_dialog.dart';
import 'package:promas/components/alert_dialogues/delete_project_dialog.dart';
import 'package:promas/components/empty_widgets/empty_widget_alt.dart';
import 'package:promas/components/main_divider.dart';
import 'package:promas/components/side_bar/main_side_bar.dart';
import 'package:promas/components/side_bar/right_side_bar.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/components/top_bar/main_top_bar.dart';
import 'package:promas/components/top_bar/mobile_app_bar.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/components/branch_list_tile.dart';
import 'package:promas/pages/projects/components/github_instruction_widget.dart';

class ProjectPage extends StatefulWidget {
  final ProjectClass project;
  const ProjectPage({super.key, required this.project});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  // final companyId = CompanyProvider().currentCompany!.id;
  final projectSearchController = TextEditingController();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final urlController = TextEditingController();
  bool isLoading = false;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
    print('Loading is now $isLoading');
  }

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    List<BranchClass> branchIn =
        returnBranch(context: context).branches
            .where(
              (bra) => bra.projectId == widget.project.uuid,
            )
            .toList();
    branchIn.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      key: _scaffoldKey,
      appBar: screenSize(context) > mobileScreen
          ? null
          : appBar(context: context, isMain: false),
      drawer: MainSideBar(isMain: false),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: screenSize(context) > tabletScreen,
            child: MainSideBar(isMain: false),
          ),
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible:
                      screenSize(context) > mobileScreen,
                  child: MainTopBar(
                    isMain: false,
                    pageName: 'Project Page',
                    isVisible: false,
                    onChanged: (value) {
                      setState(() {});
                    },
                    searchController:
                        projectSearchController,
                    globalKey: _scaffoldKey,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: theme.white(),
                          ),
                          child: SizedBox(
                            height: double.infinity,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      Material(
                                        color: Colors
                                            .transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(
                                              context,
                                            ).pop();
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(
                                                  4.0,
                                                ),
                                            child: Icon(
                                              size: 20,
                                              color: returnTheme(
                                                context:
                                                    context,
                                              ).darkGrey(),
                                              Icons
                                                  .arrow_back_ios_new_rounded,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign
                                            .center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          color:
                                              returnTheme(
                                                context:
                                                    context,
                                              ).darkGrey(),
                                        ),
                                        widget.project.name,
                                      ),
                                      Opacity(
                                        opacity:
                                            widget
                                                    .project
                                                    .githubUrl !=
                                                null
                                            ? 1
                                            : 0,
                                        child:
                                            GithubInstructionWidget(
                                              project: widget
                                                  .project,
                                            ),
                                      ),
                                    ],
                                  ),
                                  MainDivider(height: 10),
                                  SizedBox(height: 8),
                                  Text(
                                    textAlign:
                                        TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.normal,
                                      color: returnTheme(
                                        context: context,
                                      ).darkMediumGrey(),
                                    ),
                                    widget.project.desc,
                                  ),
                                  SizedBox(height: 25),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                    decoration: BoxDecoration(
                                      color:
                                          theme.isDarkMode
                                          ? theme
                                                .containerColor()
                                          : Colors
                                                .grey
                                                .shade100,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      spacing: 10,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(
                                                top: 0.0,
                                              ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .end,
                                            spacing: 5,
                                            children: [
                                              IgnorePointer(
                                                ignoring: !returnUser(
                                                  context:
                                                      context,
                                                ).currentUser!.isAdmin,
                                                child: Material(
                                                  color: Colors
                                                      .transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context:
                                                            context,
                                                        builder:
                                                            (
                                                              context,
                                                            ) {
                                                              return AddProjectDialog(
                                                                project: widget.project,
                                                                nameController: nameController,
                                                                descController: descController,
                                                                urlController: urlController,
                                                              );
                                                            },
                                                      ).then((
                                                        _,
                                                      ) {
                                                        setState(
                                                          () {},
                                                        );
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal:
                                                            8.0,
                                                        vertical:
                                                            6,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        spacing:
                                                            5,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            size: 18,
                                                            color: returnTheme(
                                                              context: context,
                                                            ).mediumGrey(),
                                                            Icons.edit_outlined,
                                                          ),
                                                          Text(
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: returnTheme(
                                                                context: context,
                                                              ).mediumGrey(),
                                                            ),
                                                            'Edit',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IgnorePointer(
                                                ignoring: !returnUser(
                                                  context:
                                                      context,
                                                ).currentUser!.isAdmin,
                                                child: Material(
                                                  color: Colors
                                                      .transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showGeneralDialog(
                                                        context:
                                                            context,
                                                        pageBuilder:
                                                            (
                                                              context,
                                                              animation,
                                                              secondaryAnimation,
                                                            ) {
                                                              return MainChatWidget(
                                                                chatType: 3,
                                                                id:
                                                                    widget.project.uuid ??
                                                                    '',
                                                              );
                                                            },
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal:
                                                            8.0,
                                                        vertical:
                                                            6,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        spacing:
                                                            5,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            size: 18,
                                                            color: returnTheme(
                                                              context: context,
                                                            ).mediumGrey(),
                                                            Icons.chat,
                                                          ),
                                                          Text(
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: returnTheme(
                                                                context: context,
                                                              ).mediumGrey(),
                                                            ),
                                                            'Chat',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IgnorePointer(
                                                ignoring: !returnUser(
                                                  context:
                                                      context,
                                                ).currentUser!.isAdmin,
                                                child: Material(
                                                  color: Colors
                                                      .transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context:
                                                            context,
                                                        builder:
                                                            (
                                                              context,
                                                            ) {
                                                              return DeleteProjectDialog(
                                                                project: widget.project,
                                                              );
                                                            },
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal:
                                                            8.0,
                                                        vertical:
                                                            6,
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        spacing:
                                                            5,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Icon(
                                                            size: 18,
                                                            color: const Color.fromARGB(
                                                              255,
                                                              255,
                                                              92,
                                                              92,
                                                            ),
                                                            Icons.delete_outlined,
                                                          ),
                                                          Text(
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: const Color.fromARGB(
                                                                255,
                                                                255,
                                                                92,
                                                                92,
                                                              ),
                                                            ),
                                                            'Delete',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  MainDivider(height: 10),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              color: returnTheme(
                                                context:
                                                    context,
                                              ).darkGrey(),
                                            ),
                                            'BRANCHES',
                                          ),
                                          IgnorePointer(
                                            ignoring: !returnUser(
                                              context:
                                                  context,
                                            ).currentUser!.isAdmin,
                                            child: Material(
                                              color: Colors
                                                  .transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  await createBranch(
                                                    context:
                                                        context,
                                                    descController:
                                                        descController,
                                                    nameController:
                                                        nameController,
                                                    projectId: widget
                                                        .project
                                                        .uuid!,
                                                  );
                                                  setState(
                                                    () {},
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        10,
                                                    horizontal:
                                                        10,
                                                  ),
                                                  child: Row(
                                                    spacing:
                                                        3,
                                                    children: [
                                                      Icon(
                                                        color: returnTheme(
                                                          context: context,
                                                        ).darkMediumGrey(),
                                                        size:
                                                            18,
                                                        Icons.add,
                                                      ),
                                                      Text(
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: returnTheme(
                                                            context: context,
                                                          ).darkMediumGrey(),
                                                        ),
                                                        'Create New Branch',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (branchIn
                                              .isNotEmpty) {
                                            return Column(
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                // Padding(
                                                //   padding: const EdgeInsets.symmetric(
                                                //     horizontal:
                                                //         20.0,
                                                //     vertical:
                                                //         5,
                                                //   ),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //         MainAxisAlignment.spaceBetween,
                                                //     children: [
                                                //       Expanded(
                                                //         child: Text(
                                                //           style: TextStyle(
                                                //             fontSize: 11,
                                                //             color: returnTheme(
                                                //               context: context,
                                                //             ).mediumGrey(),
                                                //           ),
                                                //           'Branch Name',
                                                //         ),
                                                //       ),
                                                //       // Expanded(
                                                //       //   child: Padding(
                                                //       //     padding: const EdgeInsets.symmetric(
                                                //       //       horizontal: 20.0,
                                                //       //     ),
                                                //       //     child: Text(
                                                //       //       style: TextStyle(
                                                //       //         fontSize: 11,
                                                //       //         color: returnTheme(
                                                //       //           context: context,
                                                //       //         ).mediumGrey(),
                                                //       //       ),
                                                //       //       'Level',
                                                //       //     ),
                                                //       //   ),
                                                //       // ),
                                                //       Opacity(
                                                //         opacity:
                                                //             0,
                                                //         child: Icon(
                                                //           Icons.keyboard_arrow_up_rounded,
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                Column(
                                                  spacing:
                                                      10,
                                                  children: branchIn
                                                      .map(
                                                        (
                                                          branch,
                                                        ) => BranchListTile(
                                                          action: () {
                                                            setState(
                                                              () {},
                                                            );
                                                          },
                                                          descController: descController,
                                                          nameController: nameController,
                                                          branch: branch,
                                                          projectId: widget.project.uuid!,
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                              ],
                                            );
                                          } else {
                                            return EmptyWidgetAlt(
                                              buttonText:
                                                  'Create branch',
                                              title:
                                                  'No Branch for This Project',
                                              action: () => createBranch(
                                                context:
                                                    context,
                                                descController:
                                                    descController,
                                                nameController:
                                                    nameController,
                                                projectId: widget
                                                    .project
                                                    .uuid!,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            screenSize(context) >
                            tabletScreenBig,
                        child: RightSideBar(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMenuItem {
  final String title;
  final int index;
  // final TextEditingController controller;
  // final String message;

  ChatMenuItem({
    required this.title,
    required this.index,
    // required this.controller,
    // required this.message,
  });
}

class MainChatWidget extends StatefulWidget {
  final String id;
  final int chatType;
  const MainChatWidget({
    super.key,
    required this.id,
    required this.chatType,
  });

  @override
  State<MainChatWidget> createState() =>
      _MainChatWidgetState();
}

class _MainChatWidgetState extends State<MainChatWidget> {
  @override
  void initState() {
    super.initState();
    returnChats().startRepeatingFunction(
      id: widget.id,
      chatType: widget.chatType,
    );
  }

  @override
  void dispose() {
    super.dispose();
    returnChats().stopRepeatingFunction();
  }

  TextEditingController messageController =
      TextEditingController();

  List<ChatMenuItem> mainItems = [
    ChatMenuItem(title: 'Edit', index: 1),
    ChatMenuItem(title: 'Copy', index: 2),
    ChatMenuItem(title: 'Delete', index: 3),
  ];

  List<ChatMenuItem> altItems = [
    ChatMenuItem(title: 'Reply', index: 1),
    ChatMenuItem(title: 'Copy', index: 2),
  ];

  Chats? chatEdit;

  Chats? chatReply;

  void showMenuAction({
    required GlobalKey buttonKeyy,
    required Chats chat,
  }) async {
    final RenderBox button =
        buttonKeyy.currentContext!.findRenderObject()
            as RenderBox;

    final Offset position = button.localToGlobal(
      Offset.zero,
    );

    final Size size = button.size;

    final screenSize = MediaQuery.of(context).size;

    await showMenu(
      context: context,
      color: Colors.white,
      constraints: BoxConstraints(
        maxWidth: 400,
        minWidth: 200,
      ),
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 10,
        screenSize.width - position.dx - size.width,
        screenSize.height - position.dy,
      ),
      items:
          (chat.userId == returnUser().currentUser?.id
                  ? mainItems
                  : altItems)
              .map((item) {
                return PopupMenuItem(
                  onTap: () {
                    if (chat.userId ==
                        returnUser().currentUser?.id) {
                      if (item.index == 1) {
                        chatEdit = chat;
                        setState(() {
                          messageController.text =
                              chat.message;
                        });
                      } else if (item.index == 2) {
                        copyToClipboard(
                          context,
                          chat.message,
                        );
                      } else if (item.index == 3) {
                        returnChats().deleteChat(chat.uuid);
                      }
                    } else {
                      if (item.index == 1) {
                        setState(() {
                          chatReply = chat;
                        });
                      } else if (item.index == 2) {
                        copyToClipboard(
                          context,
                          chat.message,
                        );
                      }
                    }
                  },
                  child: Text(
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    item.title,
                  ),
                );
              })
              .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              spacing: 5,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  spacing: 5,
                  children: [
                    Opacity(
                      opacity: 0,
                      child: Icon(Icons.clear),
                    ),
                    Text('Chats'),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.clear),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade400),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: returnChats(context: context)
                          .getProjectChats(
                            projectId: widget.id,
                          )
                          .map(
                            (item) => Row(
                              mainAxisAlignment:
                                  returnUser()
                                          .currentUser
                                          ?.id ==
                                      item.userId
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  key: item.key,
                                  onLongPress: () {
                                    // final buttonKeyy =
                                    //     GlobalKey();
                                    showMenuAction(
                                      buttonKeyy: item.key,
                                      chat: item,
                                    );
                                  },
                                  child: Container(
                                    constraints:
                                        BoxConstraints(
                                          maxWidth:
                                              screenSize(
                                                    context,
                                                  ) >
                                                  mobileScreen
                                              ? 400
                                              : 250,
                                        ),
                                    margin:
                                        EdgeInsets.symmetric(
                                          vertical: 3,
                                        ),
                                    // padding:
                                    //     EdgeInsets.symmetric(
                                    //       vertical: 5,
                                    //       horizontal: 8,
                                    //     ),
                                    decoration: BoxDecoration(
                                      color:
                                          returnUser()
                                                  .currentUser
                                                  ?.id ==
                                              item.userId
                                          ? const Color.fromARGB(
                                              255,
                                              46,
                                              81,
                                              110,
                                            )
                                          : Colors
                                                .grey
                                                .shade800,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft:
                                            Radius.circular(
                                              5,
                                            ),
                                        bottomRight:
                                            Radius.circular(
                                              5,
                                            ),
                                        topRight: Radius.circular(
                                          returnUser()
                                                      .currentUser
                                                      ?.id ==
                                                  item.userId
                                              ? 0
                                              : 5,
                                        ),
                                        topLeft: Radius.circular(
                                          returnUser()
                                                      .currentUser
                                                      ?.id ==
                                                  item.userId
                                              ? 5
                                              : 0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      spacing: 3,
                                      children: [
                                        // Visibility(
                                        //   visible: true,
                                        //   // chatReply !=
                                        //   // null,
                                        //   child: Container(
                                        //     padding:
                                        //         EdgeInsets.symmetric(
                                        //           vertical:
                                        //               7,
                                        //           horizontal:
                                        //               10,
                                        //         ),
                                        //     decoration: BoxDecoration(
                                        //       color: Colors
                                        //           .grey
                                        //           .shade900,
                                        //       borderRadius:
                                        //           BorderRadius.vertical(
                                        //             top:
                                        //                 Radius.circular(
                                        //                   5,
                                        //                 ),
                                        //           ),
                                        //     ),
                                        //     child: Column(
                                        //       spacing: 5,
                                        //       children: [
                                        //         Text(
                                        //           style: TextStyle(
                                        //             fontSize:
                                        //                 9,
                                        //             color: Colors
                                        //                 .grey,
                                        //           ),
                                        //           cutLongText(
                                        //             40,
                                        //             item.replyMessage ??
                                        //                 'Not Set',
                                        //           ),
                                        //         ),
                                        //         Text(
                                        //           style: TextStyle(
                                        //             fontSize:
                                        //                 9,
                                        //             color: Colors
                                        //                 .grey,
                                        //           ),
                                        //           cutLongText(
                                        //             40,
                                        //             chatReply?.message ??
                                        //                 'Not Set',
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        Visibility(
                                          visible:
                                              item.chatId ==
                                              null,
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(
                                                  5,
                                                  2,
                                                  0,
                                                  2,
                                                ),
                                            decoration:
                                                BoxDecoration(
                                                  color: Colors
                                                      .white24,
                                                ),
                                            child: Row(
                                              // mainAxisSize:
                                              //     MainAxisSize
                                              //         .max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  style: TextStyle(
                                                    fontSize:
                                                        7.5,
                                                    color: theme
                                                        .tertiaryLight(),
                                                  ),
                                                  item.userId ==
                                                          returnUser().currentUser?.id
                                                      ? 'You'
                                                      : (returnUser().users
                                                                .where(
                                                                  (
                                                                    user,
                                                                  ) =>
                                                                      user.id ==
                                                                      item.userId,
                                                                )
                                                                .isEmpty
                                                            ? (item.userName ??
                                                                  'Not Set')
                                                            : returnUser().users
                                                                  .where(
                                                                    (
                                                                      user,
                                                                    ) =>
                                                                        user.id ==
                                                                        item.userId,
                                                                  )
                                                                  .first
                                                                  .name),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(
                                                8,
                                                0,
                                                8,
                                                5,
                                              ),
                                          child: Column(
                                            spacing: 2,
                                            children: [
                                              Row(
                                                mainAxisSize:
                                                    MainAxisSize
                                                        .max,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      style: TextStyle(
                                                        fontSize:
                                                            11,
                                                        color:
                                                            Colors.white,
                                                      ),
                                                      item.message,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize:
                                                    MainAxisSize
                                                        .max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .end,
                                                children: [
                                                  Text(
                                                    style: TextStyle(
                                                      fontSize:
                                                          7,
                                                      color: Colors
                                                          .grey
                                                          .shade400,
                                                    ),
                                                    formatTime(
                                                      item.createdAt ??
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Divider(color: Colors.grey.shade300),
                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: chatReply != null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius:
                                    BorderRadius.vertical(
                                      top: Radius.circular(
                                        5,
                                      ),
                                    ),
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    child: Text(
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey,
                                      ),
                                      cutLongText(
                                        40,
                                        chatReply
                                                ?.message ??
                                            'Not Set',
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        chatReply = null;
                                      });
                                    },
                                    child: Icon(
                                      size: 15,
                                      Icons.clear,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          NormalTextfield(
                            onFieldSubmitted: (value) {
                              if (messageController
                                  .text
                                  .isNotEmpty) {
                                final chat = Chats(
                                  userName: returnUser()
                                      .currentUser!
                                      .name,
                                  userId: returnUser()
                                      .currentUser!
                                      .id!,
                                  uuid:
                                      chatEdit?.uuid ??
                                      uuidGen(),
                                  message: messageController
                                      .text
                                      .trim(),
                                  companyId: returnCompany()
                                      .currentCompany!
                                      .id!,
                                  createdAt:
                                      chatEdit != null
                                      ? chatEdit?.createdAt
                                      : DateTime.now(),
                                  projectId: widget.id,
                                  replyId: chatReply?.uuid,
                                  replyMessage:
                                      chatReply?.message,
                                  replyUserName:
                                      chatReply?.userName,
                                );
                                chatEdit != null
                                    ? returnChats()
                                          .updateChat(chat)
                                    : returnChats()
                                          .createChat(chat);
                                messageController.clear();
                              }
                            },
                            inputController:
                                messageController,
                            hintText: 'Enter Message',
                            title: 'title',
                            isOptional: true,
                            numberOfLines: 1,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      spacing: 0,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(5),
                              color: const Color.fromARGB(
                                255,
                                46,
                                81,
                                110,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (messageController
                                    .text
                                    .isNotEmpty) {
                                  final chat = Chats(
                                    userName: returnUser()
                                        .currentUser!
                                        .name,
                                    userId: returnUser()
                                        .currentUser!
                                        .id!,
                                    uuid:
                                        chatEdit?.uuid ??
                                        uuidGen(),
                                    message:
                                        messageController
                                            .text
                                            .trim(),
                                    companyId:
                                        returnCompany()
                                            .currentCompany!
                                            .id!,
                                    createdAt:
                                        chatEdit != null
                                        ? chatEdit
                                              ?.createdAt
                                        : DateTime.now(),
                                    projectId: widget.id,
                                    replyId:
                                        chatReply?.uuid,
                                    replyMessage:
                                        chatReply?.message,
                                    replyUserName:
                                        chatReply?.userName,
                                  );
                                  chatEdit != null
                                      ? returnChats()
                                            .updateChat(
                                              chat,
                                            )
                                      : returnChats()
                                            .createChat(
                                              chat,
                                            );
                                  messageController.clear();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(9),
                                child: Icon(
                                  color: Colors.white,
                                  size: 16,
                                  Icons.send,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: chatEdit != null,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(
                                        5,
                                      ),
                                  color:
                                      const Color.fromARGB(
                                        255,
                                        69,
                                        123,
                                        167,
                                      ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      messageController
                                          .clear();
                                      chatEdit = null;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      9,
                                    ),
                                    child: Icon(
                                      color: Colors.white,
                                      size: 16,
                                      Icons.clear,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class DashboardContainers extends StatelessWidget {
//   const DashboardContainers({
//     super.key,
//     required this.title,
//     required this.text,
//   });

//   final String? title;
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           vertical: 10,
//           horizontal: 5,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: const Color.fromARGB(36, 33, 33, 33),
//           ),
//           borderRadius: mainBorderRadius,
//         ),
//         child: Center(
//           child: Column(
//             spacing: 2,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 9,
//                   color: returnTheme(
//                     context: context,
//                   ).mediumGrey(),
//                 ),
//                 text,
//               ),
//               Text(
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                   color: returnTheme(
//                     context: context,
//                   ).darkMediumGrey(),
//                 ),
//                 title ?? 'Not Set',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

Future<void> createBranch({
  required BuildContext context,
  required TextEditingController nameController,
  required TextEditingController descController,
  required String projectId,
  BranchClass? branch,
}) async {
  await showDialog(
    context: context,
    builder: (contxt) {
      return AddBranchDialog(
        projectId: projectId,
        branch: branch,
        nameController: nameController,
        descController: descController,
      );
    },
  ).then((_) {
    returnBranch().clearSelectedStaffs();
  });
}

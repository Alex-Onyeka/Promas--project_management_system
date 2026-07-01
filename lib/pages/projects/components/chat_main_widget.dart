import 'package:flutter/material.dart';
import 'package:promas/classes/chats.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/components/chat_bubble_widget.dart';

class ChatMenuItem {
  final String title;
  final int index;

  ChatMenuItem({required this.title, required this.index});
}

class MainChatWidget extends StatefulWidget {
  final String? projectId;
  final String? branchId;
  final String? chatId;
  final int chatType;
  const MainChatWidget({
    super.key,
    required this.projectId,
    required this.chatType,
    required this.chatId,
    required this.branchId,
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
      id:
          widget.projectId ??
          widget.branchId ??
          widget.chatId,
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
                      fontSize: 11,
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                spacing: 5,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      spacing: 5,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 5,
                                ),
                            child: Icon(
                              size: 18,
                              Icons
                                  .arrow_back_ios_new_rounded,
                            ),
                          ),
                        ),

                        Text(
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          'Chats',
                        ),
                        Opacity(
                          opacity: 0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 5,
                                ),
                            child: Icon(Icons.clear),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider(
                  //   color: Colors.grey.shade400,
                  //   height: 0,
                  // ),
                  Expanded(
                    child: Stack(
                      children: [
                        Image.asset(
                          height: screenHeight(context),
                          fit: BoxFit.cover,
                          chatBackground,
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                      horizontal: 15,
                                    ),
                                child: ListView(
                                  reverse: true,
                                  children: returnChats(context: context)
                                      .returnMainChats(
                                        id:
                                            widget
                                                .projectId ??
                                            widget
                                                .branchId ??
                                            widget.chatId ??
                                            '',
                                        index:
                                            widget.chatType,
                                      )
                                      .map(
                                        (item) => Row(
                                          mainAxisAlignment:
                                              returnUser()
                                                      .currentUser
                                                      ?.id ==
                                                  item.userId
                                              ? MainAxisAlignment
                                                    .end
                                              : MainAxisAlignment
                                                    .start,
                                          children: [
                                            ChatBubbleWidget(
                                              item: item,
                                              replyUuid:
                                                  chatEdit
                                                      ?.uuid ??
                                                  chatReply
                                                      ?.uuid,
                                              replyAction: () {
                                                if (item.userId !=
                                                    returnUser()
                                                        .currentUser
                                                        ?.id) {
                                                  setState(() {
                                                    chatReply =
                                                        item;
                                                  });
                                                  return false;
                                                }
                                              },
                                              longPress: () {
                                                showMenuAction(
                                                  buttonKeyy:
                                                      item.key,
                                                  chat:
                                                      item,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Visibility(
                                          visible:
                                              chatReply !=
                                              null,
                                          child: Container(
                                            padding:
                                                EdgeInsets.symmetric(
                                                  vertical:
                                                      10,
                                                  horizontal:
                                                      10,
                                                ),
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .grey
                                                  .shade300,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top:
                                                        Radius.circular(
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
                                                      fontSize:
                                                          9,
                                                      color: Colors
                                                          .grey
                                                          .shade700,
                                                    ),
                                                    cutLongText(
                                                      60,
                                                      chatReply?.message ??
                                                          'Not Set',
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      chatReply =
                                                          null;
                                                    });
                                                  },
                                                  child: Icon(
                                                    size:
                                                        15,
                                                    Icons
                                                        .clear,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        NormalTextfield(
                                          onFieldSubmitted:
                                              (value) {
                                                createChat();
                                              },
                                          inputController:
                                              messageController,
                                          hintText:
                                              'Enter Message',
                                          title: 'title',
                                          isOptional: true,
                                          numberOfLines: 1,
                                          showTitle: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Material(
                                        color: Colors
                                            .transparent,
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(
                                                  5,
                                                ),
                                            color:
                                                const Color.fromARGB(
                                                  255,
                                                  46,
                                                  81,
                                                  110,
                                                ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              createChat();
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.all(
                                                    9,
                                                  ),
                                              child: Icon(
                                                color: Colors
                                                    .white,
                                                size: 16,
                                                Icons.send,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            chatEdit !=
                                            null,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(
                                                left: 5.0,
                                              ),
                                          child: Material(
                                            color: Colors
                                                .transparent,
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
                                                    chatEdit =
                                                        null;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.all(
                                                        9,
                                                      ),
                                                  child: Icon(
                                                    color: Colors
                                                        .white,
                                                    size:
                                                        16,
                                                    Icons
                                                        .clear,
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
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Divider(
                  //   color: Colors.grey.shade300,
                  //   height: 0,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createChat() {
    if (messageController.text.isNotEmpty) {
      final chat = Chats(
        userName: returnUser().currentUser!.name,
        userId: returnUser().currentUser!.id!,
        uuid: chatEdit?.uuid ?? uuidGen(),
        message: messageController.text.trim(),
        companyId: returnCompany().currentCompany!.id!,
        createdAt: chatEdit != null
            ? chatEdit?.createdAt
            : DateTime.now(),
        projectId: widget.projectId,
        branchId: widget.branchId,
        chatId: widget.chatId,
        replyId: chatReply?.uuid,
        replyMessage: chatReply?.message,
        replyUserName: chatReply?.userName,
      );
      chatEdit != null
          ? returnChats().updateChat(chat)
          : returnChats().createChat(chat);
      messageController.clear();
      chatEdit = null;
      chatReply = null;
    }
  }
}

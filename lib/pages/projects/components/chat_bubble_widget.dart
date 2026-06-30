import 'package:flutter/material.dart';
import 'package:promas/classes/chats.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';

class ChatBubbleWidget extends StatefulWidget {
  final Chats item;
  final String? replyUuid;
  final Function()? longPress;
  final Function()? replyAction;
  const ChatBubbleWidget({
    super.key,
    required this.item,
    required this.longPress,
    this.replyUuid,
    this.replyAction,
  });

  @override
  State<ChatBubbleWidget> createState() =>
      _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState
    extends State<ChatBubbleWidget> {
  double offset = 0;
  bool actionTriggered = false;
  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          setState(() {
            offset += details.delta.dx;
            offset = offset.clamp(
              0.0,
              50.0,
            ); // Maximum slide
          });
        }
      },
      onHorizontalDragEnd: (_) {
        if (offset >= 40 && !actionTriggered) {
          actionTriggered = true;
          widget.replyAction != null
              ? widget.replyAction!()
              : {};
        }

        setState(() {
          offset = 0;
          actionTriggered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(offset, 0, 0),
        child: InkWell(
          key: widget.item.key,
          onLongPress: widget.longPress,
          child: Container(
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(
              maxWidth: screenSize(context) > mobileScreen
                  ? 400
                  : 250,
            ),
            margin: EdgeInsets.symmetric(vertical: 3),
            // padding:
            //     EdgeInsets.symmetric(
            //       vertical: 5,
            //       horizontal: 8,
            //     ),
            decoration: BoxDecoration(
              color:
                  (widget.replyUuid == null ||
                      widget.replyUuid == widget.item.uuid)
                  ? (returnUser().currentUser?.id ==
                            widget.item.userId
                        ? const Color.fromARGB(
                            255,
                            46,
                            81,
                            110,
                          )
                        : Colors.grey.shade800)
                  : Colors.grey.shade400,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
                topRight: Radius.circular(
                  returnUser().currentUser?.id ==
                          widget.item.userId
                      ? 0
                      : 5,
                ),
                topLeft: Radius.circular(
                  returnUser().currentUser?.id ==
                          widget.item.userId
                      ? 5
                      : 0,
                ),
              ),
            ),
            child: Column(
              // spacing: 3,
              children: [
                Visibility(
                  visible: widget.item.replyId != null,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        27,
                        50,
                        70,
                      ),
                      // borderRadius: BorderRadius.vertical(
                      //   top: Radius.circular(5),
                      // ),
                    ),
                    child: Column(
                      // spacing: 5,
                      children: [
                        Row(
                          children: [
                            Text(
                              style: TextStyle(
                                fontSize: 8,
                                color: theme
                                    .secondaryLight(),
                              ),
                              cutLongText(
                                40,
                                widget.item.replyUserName ??
                                    'Not Set',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                              cutLongText(
                                50,
                                widget.item.replyMessage ??
                                    'Not Set',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.item.chatId == null,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      5,
                      2,
                      0,
                      2,
                    ),
                    margin: EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                    ),
                    child: Row(
                      // mainAxisSize:
                      //     MainAxisSize
                      //         .max,
                      mainAxisAlignment:
                          MainAxisAlignment.start,
                      children: [
                        Text(
                          style: TextStyle(
                            fontSize: 7.5,
                            color: theme.tertiaryLight(),
                          ),
                          widget.item.userId ==
                                  returnUser()
                                      .currentUser
                                      ?.id
                              ? 'You'
                              : (returnUser().users
                                        .where(
                                          (user) =>
                                              user.id ==
                                              widget
                                                  .item
                                                  .userId,
                                        )
                                        .isEmpty
                                    ? (widget
                                              .item
                                              .userName ??
                                          'Not Set')
                                    : returnUser().users
                                          .where(
                                            (user) =>
                                                user.id ==
                                                widget
                                                    .item
                                                    .userId,
                                          )
                                          .first
                                          .name),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    8,
                    0,
                    8,
                    5,
                  ),
                  child: Column(
                    spacing: 2,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                              widget.item.message,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          Text(
                            style: TextStyle(
                              fontSize: 7,
                              color: Colors.grey.shade400,
                            ),
                            formatTime(
                              widget.item.createdAt ??
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
      ),
    );
  }
}

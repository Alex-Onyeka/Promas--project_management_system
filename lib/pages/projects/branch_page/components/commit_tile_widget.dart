import 'package:flutter/material.dart';
import 'package:promas/classes/commit.dart';
import 'package:promas/constants/formats.dart';
import 'package:promas/main.dart';

class CommitTileWidget extends StatefulWidget {
  const CommitTileWidget({super.key, required this.commit});

  final Commit commit;

  @override
  State<CommitTileWidget> createState() =>
      _CommitTileWidgetState();
}

class _CommitTileWidgetState
    extends State<CommitTileWidget> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    var theme = returnTheme(context: context);
    return Column(
      spacing: 8,
      children: [
        Material(
          color: theme.containerColor(),
          child: InkWell(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: Row(
                spacing: 5,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(
                      size: 14,
                      color: Colors.grey.shade500,
                      Icons.account_tree_outlined,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      widget.commit.message,
                    ),
                  ),
                  Icon(
                    size: 20,
                    color: Colors.grey.shade500,
                    isOpen
                        ? Icons.arrow_drop_up_outlined
                        : Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isOpen,
          child: Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              border: Border(
                left: BorderSide(
                  color: Colors.grey.shade300,
                ),
                right: BorderSide(
                  color: Colors.grey.shade300,
                ),
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              spacing: 10,
              children: [
                CommitInfoRow(
                  title: 'Athor Name',
                  value: widget.commit.authorName,
                ),
                CommitInfoRow(
                  title: 'Athor Email',
                  value:
                      widget.commit.authorEmail ??
                      'Email not set',
                ),
                CommitInfoRow(
                  title: 'Created Date',
                  value: formateDate(widget.commit.date),
                ),
                CommitInfoRow(
                  title: 'Additions',
                  value: formatLargeNumber(
                    widget.commit.additions.toString(),
                  ),
                ),
                CommitInfoRow(
                  title: 'Deletions',
                  value: formatLargeNumber(
                    widget.commit.deletions.toString(),
                  ),
                ),
                CommitInfoRow(
                  title: 'Total',
                  value: formatLargeNumber(
                    widget.commit.total.toString(),
                  ),
                ),
                CommitInfoRow(
                  title: 'Files Changed',
                  value: formatLargeNumber(
                    widget.commit.files.length.toString(),
                  ),
                ),
                Builder(
                  builder: (context) {
                    List<CommitFile> files =
                        widget.commit.files;
                    files.sort(
                      (a, b) => (a.status ?? '').compareTo(
                        (b.status ?? ''),
                      ),
                    );
                    return Column(
                      spacing: 5,
                      children: files
                          .map(
                            (file) => CommitFileTileWidget(
                              file: file,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CommitFileTileWidget extends StatefulWidget {
  const CommitFileTileWidget({
    super.key,
    required this.file,
  });
  final CommitFile file;

  @override
  State<CommitFileTileWidget> createState() =>
      _CommitFileTileWidgetState();
}

class _CommitFileTileWidgetState
    extends State<CommitFileTileWidget> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: widget.file.status == 'removed'
              ? const Color.fromARGB(17, 239, 83, 80)
              : widget.file.status == 'added'
              ? const Color.fromARGB(22, 76, 175, 79)
              : Colors.grey.shade100,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: Text(
                      style: TextStyle(fontSize: 8.5),
                      widget.file.filename,
                    ),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Text(
                        style: TextStyle(fontSize: 8.5),
                        'Status:',
                      ),
                      Text(
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color:
                              widget.file.status ==
                                  'removed'
                              ? Colors.red.shade400
                              : widget.file.status ==
                                    'added'
                              ? Colors.green
                              : null,
                        ),
                        widget.file.status?.toUpperCase() ??
                            'Not Set',
                      ),
                      Icon(
                        size: 16,
                        isOpen
                            ? Icons
                                  .keyboard_arrow_up_rounded
                            : Icons
                                  .keyboard_arrow_down_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isOpen,
              child: Container(
                color: Colors.grey.shade400,
                width: double.infinity,
                height: 1,
              ),
            ),
            Visibility(
              visible: isOpen,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  8.0,
                  10,
                  8,
                  15,
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    CommitFileInfoRow(
                      title: 'Additions',
                      value: formatLargeNumber(
                        widget.file.additions.toString(),
                      ),
                    ),
                    CommitFileInfoRow(
                      title: 'Deletions',
                      value: formatLargeNumber(
                        widget.file.deletions.toString(),
                      ),
                    ),
                    CommitFileInfoRow(
                      title: 'Total',
                      value: formatLargeNumber(
                        widget.file.changes.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommitInfoRow extends StatelessWidget {
  const CommitInfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          "$title:",
        ),
        Text(
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          value,
        ),
      ],
    );
  }
}

class CommitFileInfoRow extends StatelessWidget {
  const CommitFileInfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
          "$title:",
        ),
        Text(
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
          value,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:promas/classes/branch_class.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/projects/branch_page/branch_page.dart';

class BranchListTile extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final BranchClass branch;
  final String projectId;
  final Function() action;
  const BranchListTile({
    super.key,
    required this.branch,
    required this.nameController,
    required this.descController,
    required this.action,
    required this.projectId,
  });

  @override
  State<BranchListTile> createState() =>
      _BranchListTileState();
}

class _BranchListTileState extends State<BranchListTile> {
  // bool isOpen = false;
  // bool isLoading = false;
  // void toggleLoading() {
  //   setState(() {
  //     isLoading = !isLoading;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: returnTheme(context: context).white(),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(22, 0, 0, 0),
            blurRadius: 5,
          ),
        ],
      ),
      // padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BranchPage(
                      branch: widget.branch,
                      descController: widget.descController,
                      nameController: widget.nameController,
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 25,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: returnTheme(
                          context: context,
                        ).darkMediumGrey(),
                      ),
                      widget.branch.name.toUpperCase(),
                    ),
                  ),
                  Icon(
                    size: 16,
                    color: returnTheme(
                      context: context,
                    ).mediumGrey(),
                    Icons.arrow_forward_ios_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

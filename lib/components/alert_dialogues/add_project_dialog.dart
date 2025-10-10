import 'package:flutter/material.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';

class AddProjectDialog extends StatefulWidget {
  final Function() addProject;
  final TextEditingController nameController;
  final TextEditingController descController;
  const AddProjectDialog({
    super.key,
    required this.addProject,
    required this.nameController,
    required this.descController,
  });

  @override
  State<AddProjectDialog> createState() =>
      _AddProjectDialogState();
}

class _AddProjectDialogState
    extends State<AddProjectDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertPlaceholder(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            HeadingSection(
              title: 'Create New Project',
              subText:
                  'Fill The Form To Create New Project',
            ),
            SizedBox(height: 10),
            NormalTextfield(
              inputController: widget.nameController,
              hintText: 'Enter Project Name',
              title: 'Project Name',
              isOptional: false,
            ),
            SizedBox(height: 3),
            NormalTextfield(
              inputController: widget.descController,
              hintText: 'Enter Project Description',
              title: 'Project Description',
              isOptional: false,
              numberOfLines: 3,
            ),
            SizedBox(height: 6),
            MainButton(
              action: () {
                if (_formKey.currentState!.validate()) {
                  widget.addProject();
                  widget.nameController.clear();
                  widget.descController.clear();
                  Navigator.of(context).pop();
                }
              },
              title: 'Create Project',
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
    );
  }
}

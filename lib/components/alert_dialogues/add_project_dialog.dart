import 'package:flutter/material.dart';
import 'package:promas/classes/project_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/main.dart';
import 'package:promas/providers/company_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final ProjectClass? project;
  const AddProjectDialog({
    super.key,
    required this.nameController,
    required this.descController,
    this.project,
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
  void initState() {
    super.initState();
    if (widget.project != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.nameController.text = widget.project!.name;
        widget.descController.text = widget.project!.desc;
      });
    }
  }

  bool isLoading = false;

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

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
                title: widget.project != null
                    ? 'Update Project'
                    : 'Create New Project',
                subText:
                    'Fill The Form To ${widget.project != null ? 'Update Project' : 'Create New Project'}',
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
                action: () async {
                  if (_formKey.currentState!.validate()) {
                    toggleLoading(true);
                    if (widget.project == null) {
                      await returnProject(
                        context,
                        listen: false,
                      ).createProject(
                        ProjectClass(
                          createdAt: DateTime.now(),
                          lastUpdate: DateTime.now(),
                          name: widget.nameController.text,
                          desc: widget.descController.text,
                          companyId: CompanyProvider()
                              .currentCompany!
                              .id,
                        ),
                      );
                    } else {
                      await returnProject(
                        context,
                        listen: false,
                      ).updateProject(
                        widget.project!.uuid!,
                        ProjectClass(
                          createdAt: DateTime.now(),
                          lastUpdate: DateTime.now(),
                          name: widget.nameController.text,
                          desc: widget.descController.text,
                          companyId: CompanyProvider()
                              .currentCompany!
                              .id,
                        ),
                      );
                    }
                    widget.nameController.clear();
                    widget.descController.clear();
                    toggleLoading(false);
                    Navigator.of(context).pop();
                  }
                },
                title: widget.project != null
                    ? 'Update Project'
                    : 'Create Project',
                loadingWidget: isLoading,
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

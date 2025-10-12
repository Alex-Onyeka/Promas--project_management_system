import 'package:flutter/material.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/main.dart';

class EditProfileDialog extends StatefulWidget {
  final TextEditingController nameController;
  final UserClass user;
  const EditProfileDialog({
    super.key,
    required this.nameController,
    required this.user,
  });

  @override
  State<EditProfileDialog> createState() =>
      _EditProfileDialogState();
}

class _EditProfileDialogState
    extends State<EditProfileDialog> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  bool isLoading = false;

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.nameController.text = widget.user.name;
      setState(() {});
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
                title: 'Update Profile Name',
                subText: 'Fill The Form To Update Profile',
              ),
              SizedBox(height: 10),
              NormalTextfield(
                inputController: widget.nameController,
                hintText: 'Enter Project Name',
                title: 'Project Name',
                isOptional: false,
              ),
              SizedBox(height: 6),
              MainButton(
                action: () async {
                  if (_formKey.currentState!.validate()) {
                    toggleLoading(true);
                    widget.user.name =
                        widget.nameController.text;
                    await returnUser(
                      context,
                      listen: false,
                    ).updateUser(widget.user);
                    widget.nameController.clear();
                    toggleLoading(false);
                    Navigator.of(context).pop();
                  }
                },
                title: 'Update Profile',
                loadingWidget: isLoading,
              ),
              SizedBox(height: 4),
              SecondaryButton(
                title: 'Cancel',
                action: () {
                  widget.nameController.clear();
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

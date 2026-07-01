import 'package:flutter/material.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/base_page.dart';
import 'package:promas/services/auth_service.dart';

class EditProfileDialog extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController gitHubAlias;
  final UserClass user;
  const EditProfileDialog({
    super.key,
    required this.nameController,
    required this.user,
    required this.gitHubAlias,
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
      widget.gitHubAlias.text =
          widget.user.gitHubAlias == null
          ? ''
          : widget.user.gitHubAlias!;
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
                hintText: 'Enter User Name',
                title: 'User Name',
                isOptional: false,
              ),
              SizedBox(height: 4),
              NormalTextfield(
                inputController: widget.gitHubAlias,
                hintText: 'Enter Github Alias(Email)',
                title: 'Github Alias/Email',
                isOptional: true,
              ),
              SizedBox(height: 10),
              MainButton(
                action: () async {
                  if (_formKey.currentState!.validate()) {
                    toggleLoading(true);
                    widget.user.name =
                        widget.nameController.text;
                    widget.user.gitHubAlias =
                        widget.gitHubAlias.text;
                    await returnUser().updateUser(
                      widget.user,
                    );
                    widget.nameController.clear();
                    widget.gitHubAlias.clear();
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
                  widget.gitHubAlias.clear();
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

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState
    extends State<DeleteAccountDialog> {
  bool isLoading = false;

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertPlaceholder(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            HeadingSection(
              title: 'Delete Account',
              subText:
                  'Are you sure you want to delete your account?',
            ),
            SizedBox(height: 10),
            MainButton(
              action: () async {
                toggleLoading(true);
                var res = await AuthService()
                    .deleteAuthAccount();
                if (res == 1) {
                  var useracc = returnUser().currentUser!;

                  await returnUser().deleteUser(
                    useracc.id!,
                  );
                  if (useracc.isSuperAdmin()) {
                    await returnCompany().deleteCompany(
                      returnCompany().currentCompany!.id!,
                    );
                  }
                  toggleLoading(false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BasePage();
                      },
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              title: 'Delete Account',
              loadingWidget: isLoading,
            ),
            SizedBox(height: 4),
            SecondaryButton(
              title: 'Cancel',
              action: () {
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

import 'package:flutter/material.dart';
import 'package:promas/classes/company_class.dart';
import 'package:promas/components/alert_dialogues/alert_placeholder.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/main.dart';

class EditCompanyDialog extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final CompanyClass company;
  const EditCompanyDialog({
    super.key,
    required this.nameController,
    required this.descController,
    required this.company,
  });

  @override
  State<EditCompanyDialog> createState() =>
      EditCompanyDialogState();
}

class EditCompanyDialogState
    extends State<EditCompanyDialog> {
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
      widget.nameController.text = widget.company.name;
      widget.descController.text =
          widget.company.desc.isEmpty
          ? ''
          : widget.company.desc;
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
                title: 'Update Company Details',
                subText: 'Fill The Form To Update Company',
              ),
              SizedBox(height: 10),
              NormalTextfield(
                inputController: widget.nameController,
                hintText: 'Enter Company Name',
                title: 'Company Name',
                isOptional: false,
              ),
              SizedBox(height: 6),
              NormalTextfield(
                inputController: widget.descController,
                numberOfLines: 3,
                hintText: 'Enter Company Description',
                title: 'Company Description',
                isOptional: true,
              ),
              SizedBox(height: 6),
              MainButton(
                action: () async {
                  if (_formKey.currentState!.validate()) {
                    toggleLoading(true);
                    widget.company.name =
                        widget.nameController.text;
                    widget.company.desc =
                        widget.descController.text;
                    await returnCompany(
                      context,
                      listen: false,
                    ).updateCompany(
                      widget.company.id!,
                      widget.company,
                    );
                    widget.nameController.clear();
                    widget.descController.clear();
                    toggleLoading(false);
                    Navigator.of(context).pop();
                  }
                },
                title: 'Update Company',
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

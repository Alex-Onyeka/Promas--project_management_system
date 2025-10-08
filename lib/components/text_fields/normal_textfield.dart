import 'package:flutter/material.dart';

class NormalTextfield extends StatelessWidget {
  final TextEditingController? inputController;
  final String title;
  final String hintText;
  final int? numberOfLines;
  final bool isOptional;
  final bool? showTitle;
  final Function(String value)? onChanged;

  const NormalTextfield({
    super.key,
    required this.inputController,
    required this.hintText,
    required this.title,
    required this.isOptional,
    this.numberOfLines,
    this.showTitle,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 3,
      children: [
        Visibility(
          visible:
              showTitle == null ||
              (showTitle != null && showTitle == true),
          child: Text(
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.normal,
            ),
            '$title${isOptional ? ' (Optional)' : ''}',
          ),
        ),
        TextFormField(
          maxLines: numberOfLines ?? 1,
          style: TextStyle(fontSize: 13),
          controller: inputController,
          enableSuggestions: true,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (!isOptional && value.toString().isEmpty) {
              return '$title Field Can\'t be Empty';
            } else {
              return null;
            }
          },
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            isCollapsed: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

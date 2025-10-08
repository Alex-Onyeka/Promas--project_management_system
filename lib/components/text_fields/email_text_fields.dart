import 'package:flutter/material.dart';
import 'package:promas/main.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? emailController;
  final bool isOptional;

  const EmailTextField({
    super.key,
    required this.emailController,
    required this.isOptional,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 3,
      children: [
        Text(
          style: TextStyle(
            color: returnTheme(context).mediumGrey(),
            fontSize: 11,
            fontWeight: FontWeight.normal,
          ),
          'Email ${isOptional ? '(Optional)' : ''}',
        ),
        TextFormField(
          style: TextStyle(
            color: returnTheme(context).mediumGrey(),
            fontSize: 13,
          ),
          controller: emailController,
          enableSuggestions: true,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.none,
          validator: (value) {
            if (isOptional == false &&
                value.toString().isEmpty) {
              return 'Email Field Can\'t be Empty';
            } else if (value.toString().isNotEmpty &&
                (!value!.contains('@') ||
                    !value.contains('.'))) {
              return 'Please enter a Valid Email';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            isCollapsed: true,
            hintText: 'Enter Email',
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

import 'package:flutter/material.dart';
import 'package:promas/main.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? passwordController;
  final bool isConfirmPassword;
  final String? passwordValue;
  const PasswordTextField({
    super.key,
    required this.passwordController,
    required this.isConfirmPassword,
    this.passwordValue,
  });

  @override
  State<PasswordTextField> createState() =>
      _PasswordTextFieldState();
}

class _PasswordTextFieldState
    extends State<PasswordTextField> {
  bool obscureText = true;
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
          widget.isConfirmPassword
              ? 'Confirm Password'
              : 'Password',
        ),
        TextFormField(
          style: TextStyle(
            color: returnTheme(context).mediumGrey(),
            fontSize: 13,
          ),
          controller: widget.passwordController,
          enableSuggestions: false,
          keyboardType: TextInputType.visiblePassword,
          obscureText: obscureText,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'Password Field Can\'t be Empty';
            } else if (value.toString().isEmpty &&
                value.toString().length < 6) {
              return 'Password Must be Six Characters or more';
            } else if (value.toString().isEmpty &&
                widget.passwordValue != null &&
                widget.passwordController?.text !=
                    widget.passwordValue) {
              return 'Password and Confirm Password must be the same';
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
            hintText: widget.isConfirmPassword
                ? 'Confirm Password'
                : 'Enter Password',
            hintStyle: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              child: Icon(
                color: Colors.grey,
                size: 20,
                obscureText
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
            ),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

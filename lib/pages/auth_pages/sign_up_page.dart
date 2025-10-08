import 'package:flutter/material.dart';
import 'package:promas/components/alert_dialogues/error_alert.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/containers/auth_container.dart';
import 'package:promas/components/loading_widget.dart';
import 'package:promas/components/text_fields/email_text_fields.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/components/text_fields/password_text_fields.dart';
import 'package:promas/pages/base_page.dart';
import 'package:promas/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  final Function() action;
  const SignUpPage({super.key, required this.action});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  void switchLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Transform.rotate(
                        angle: -0.18,
                        child: AuthContainer(height: 615),
                      ),
                      AuthContainer(
                        widget: SignUpForm(
                          switchLoading: (value) {
                            switchLoading(value);
                          },
                          action: widget.action,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isLoading,
          child: LoadingWidget(
            action: () {
              switchLoading(false);
            },
          ),
        ),
      ],
    );
  }
}

class SignUpForm extends StatefulWidget {
  final Function()? action;
  final Function(bool value) switchLoading;
  const SignUpForm({
    super.key,
    this.action,
    required this.switchLoading,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  Future<void> createAccount() async {
    if (_formKey.currentState!.validate()) {
      widget.switchLoading(true);
      var res = await AuthService().signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
      );

      if (res == null) {
        widget.switchLoading(false);
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return ErrorAlert(
              message:
                  'An error occoured while trying Create Your account. Please check your credentials and Network and try again.',
              title: 'Error Singing In',
            );
          },
        );
      } else {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BasePage();
              },
            ),
          );
        }
      }
    }
  }

  TextEditingController nameController =
      TextEditingController();
  TextEditingController emailController =
      TextEditingController();
  TextEditingController passwordController =
      TextEditingController();
  TextEditingController confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 5,
        children: [
          Text(
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            'Sign Up',
          ),
          Text(
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            'Enter Auth info to create your Promas Account',
          ),
          SizedBox(height: 5),
          Container(
            height: 3,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 10),
          NormalTextfield(
            inputController: nameController,
            hintText: 'Enter Name',
            isOptional: false,
            title: 'Full Name',
          ),
          SizedBox(height: 5),
          EmailTextField(
            emailController: emailController,
            isOptional: false,
          ),
          SizedBox(height: 5),
          PasswordTextField(
            isConfirmPassword: false,
            passwordController: passwordController,
            passwordValue: confirmPasswordController.text,
          ),
          SizedBox(height: 5),
          PasswordTextField(
            isConfirmPassword: true,
            passwordController: confirmPasswordController,
            passwordValue: passwordController.text,
          ),
          SizedBox(height: 10),
          MainButton(
            title: 'Create Account',
            action: () async {
              await createAccount();
            },
          ),
          SizedBox(height: 7),
          Text(
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
            'Do you have an Account?',
          ),
          SizedBox(height: 7),
          SecondaryButton(
            action: widget.action,
            title: 'Log in',
          ),
        ],
      ),
    );
  }
}

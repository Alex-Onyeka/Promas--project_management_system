import 'package:flutter/material.dart';
import 'package:promas/components/alert_dialogues/error_alert.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/containers/auth_container.dart';
import 'package:promas/components/loading_widget.dart';
import 'package:promas/components/text_fields/email_text_fields.dart';
import 'package:promas/components/text_fields/password_text_fields.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/base_page.dart';
import 'package:promas/providers/theme_provider.dart';
import 'package:promas/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function() action;
  const LoginPage({super.key, required this.action});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
          backgroundColor: returnTheme(context).white(),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Transform.rotate(
                        angle: -0.18,
                        child: AuthContainer(height: 470),
                      ),
                      AuthContainer(
                        widget: LoginForm(
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

class LoginForm extends StatefulWidget {
  final Function()? action;
  final Function(bool value) switchLoading;
  const LoginForm({
    super.key,
    this.action,
    required this.switchLoading,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      widget.switchLoading(true);
      var res = await AuthService().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      widget.switchLoading(false);
      if (res == null) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return ErrorAlert(
              message:
                  'An error occoured while trying to log you in. Please check your credentials and try again.',
              title: 'Error Login In',
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

  TextEditingController emailController =
      TextEditingController();
  TextEditingController passwordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 5,
        children: [
          InkWell(
            onTap: () {
              ThemeProvider().switchTheme();
            },
            child: Text(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              'Login',
            ),
          ),
          Text(
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: returnTheme(context).mediumGrey(),
            ),
            'Securely Login to your Promas Account',
          ),
          SizedBox(height: 5),
          Container(
            height: 3,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: returnTheme(context).primaryLight(),
            ),
          ),
          SizedBox(height: 10),
          EmailTextField(
            emailController: emailController,
            isOptional: false,
          ),
          SizedBox(height: 10),
          PasswordTextField(
            isConfirmPassword: false,
            passwordController: passwordController,
          ),
          SizedBox(height: 15),
          MainButton(
            title: 'Log In',
            action: () async {
              login();
            },
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              AuthService().signOut(context: context);
            },
            child: Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
              'Don\'t have an Account?',
            ),
          ),
          SizedBox(height: 10),
          SecondaryButton(
            action: widget.action,
            title: 'Create Account',
          ),
        ],
      ),
    );
  }
}

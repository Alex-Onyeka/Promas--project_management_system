import 'package:flutter/material.dart';
import 'package:promas/classes/company_class.dart';
import 'package:promas/classes/request_class.dart';
import 'package:promas/classes/user_class.dart';
import 'package:promas/components/alert_dialogues/error_alert.dart';
import 'package:promas/components/buttons/main_button.dart';
import 'package:promas/components/buttons/secondary_button.dart';
import 'package:promas/components/containers/auth_container.dart';
import 'package:promas/components/loading_widget.dart';
import 'package:promas/components/sections/heading_section.dart';
import 'package:promas/components/text_fields/email_text_fields.dart';
import 'package:promas/components/text_fields/normal_textfield.dart';
import 'package:promas/constants/general_constants.dart';
import 'package:promas/main.dart';
import 'package:promas/pages/home.dart';
import 'package:promas/providers/company_provider.dart';
import 'package:promas/providers/requests_provider.dart';
import 'package:promas/providers/user_provider.dart';
import 'package:promas/services/auth_service.dart';

class SetCompanyPage extends StatefulWidget {
  const SetCompanyPage({super.key});

  @override
  State<SetCompanyPage> createState() =>
      _SetCompanyPageState();
}

class _SetCompanyPageState extends State<SetCompanyPage> {
  bool isLoading = false;
  void switchAction(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  TextEditingController companyController =
      TextEditingController();

  void clearController(bool value) {
    setState(() {
      isVisible = value;
      companyController.clear();
    });
  }

  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await CompanyProvider().getAllCompanies();
      setState(() {});
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
                        widget: CreateCustomerForm(
                          switchAction: (value) {
                            switchAction(value);
                          },
                          action: () {
                            print('Beans');
                            clearController(true);
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return AlertDialog();
                            //   },
                            // );
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return StatefulBuilder(
                            //       builder: (context, setState) {
                            //         return AlertPlaceholder(
                            //           isMin: false,
                            //           content:
                            //           Column(
                            //             mainAxisSize:
                            //                 MainAxisSize
                            //                     .max,
                            //             spacing: 5,
                            //             children: [
                            //               HeadingSection(
                            //                 title:
                            //                     'Select a Company',
                            //                 subText:
                            //                     'Select a company, and send a request to add you to their staff.',
                            //               ),
                            //               SizedBox(
                            //                 height: 10,
                            //               ),
                            //               NormalTextfield(
                            //                 showTitle:
                            //                     false,
                            //                 inputController:
                            //                     companyController,
                            //                 hintText:
                            //                     'Search Company Name',
                            //                 title: 'title',
                            //                 isOptional:
                            //                     false,
                            //               ),
                            //               SizedBox(
                            //                 height: 200,
                            //                 child: Builder(
                            //                   builder: (context) {
                            //                     List<
                            //                       CompanyClass
                            //                     >
                            //                     companies =
                            //                         CompanyProvider()
                            //                             .companies;
                            //                     if (companies
                            //                         .isEmpty) {
                            //                       return Center(
                            //                         child: Text(
                            //                           'No Companies Found',
                            //                         ),
                            //                       );
                            //                     } else {
                            //                       // return Container();
                            //                       return ListView.builder(
                            //                         itemCount:
                            //                             companies.length,
                            //                         itemBuilder:
                            //                             (
                            //                               context,
                            //                               index,
                            //                             ) {
                            //                               CompanyClass
                            //                               company = companies[index];
                            //                               return ListTile(
                            //                                 onTap: () {},
                            //                                 title: Row(
                            //                                   spacing: 10,
                            //                                   mainAxisSize: MainAxisSize.min,
                            //                                   children: [
                            //                                     Icon(
                            //                                       size: 20,
                            //                                       color: returnTheme(
                            //                                         context,
                            //                                       ).primaryLight(),
                            //                                       Icons.home_work_outlined,
                            //                                     ),
                            //                                     Text(
                            //                                       style: TextStyle(
                            //                                         fontSize: 13,
                            //                                         color: returnTheme(
                            //                                           context,
                            //                                         ).darkGrey(),
                            //                                       ),
                            //                                       company.name,
                            //                                     ),
                            //                                   ],
                            //                                 ),
                            //                                 trailing: Icon(
                            //                                   size: 20,
                            //                                   color: returnTheme(
                            //                                     context,
                            //                                   ).darkMediumGrey(),
                            //                                   Icons.add,
                            //                                 ),
                            //                               );
                            //                             },
                            //                       );
                            //                     }
                            //                   },
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         );
                            //       },
                            //     );
                            //   },
                            // );
                          },
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
          visible: isVisible,
          child: GestureDetector(
            onTap: () {
              clearController(false);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color.fromARGB(50, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: mainBorderRadius,
                        color: Colors.white,
                      ),
                      width:
                          screenSize(context) >=
                              mobileScreen
                          ? 500
                          : null,
                      height:
                          MediaQuery.of(
                            context,
                          ).size.height -
                          (MediaQuery.of(
                                context,
                              ).size.height *
                              0.05),
                      margin: EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        spacing: 5,
                        children: [
                          HeadingSection(
                            action: () {
                              clearController(false);
                            },
                            title: 'Select a Company',
                            subText:
                                'Select a company, and send a request to add you to their staff.',
                          ),
                          SizedBox(height: 10),
                          NormalTextfield(
                            onChanged: (value) {
                              setState(() {});
                            },
                            showTitle: false,
                            inputController:
                                companyController,
                            hintText: 'Search Company Name',
                            title: 'title',
                            isOptional: false,
                          ),
                          SizedBox(
                            height: 400,
                            child: Builder(
                              builder: (context) {
                                List<CompanyClass>
                                companies =
                                    companyController
                                        .text
                                        .isNotEmpty
                                    ? CompanyProvider()
                                          .companies
                                          .where(
                                            (comp) => comp
                                                .name
                                                .toLowerCase()
                                                .contains(
                                                  companyController
                                                      .text
                                                      .toLowerCase(),
                                                ),
                                          )
                                          .toList()
                                    : CompanyProvider()
                                          .companies;
                                if (companies.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No Companies Found',
                                    ),
                                  );
                                } else {
                                  // return Container();
                                  return ListView.builder(
                                    itemCount:
                                        companyController
                                            .text
                                            .isNotEmpty
                                        ? companies
                                              .where(
                                                (
                                                  comp,
                                                ) => comp
                                                    .name
                                                    .toLowerCase()
                                                    .contains(
                                                      companyController
                                                          .text
                                                          .toLowerCase(),
                                                    ),
                                              )
                                              .length
                                        : companies.length,
                                    itemBuilder:
                                        (context, index) {
                                          CompanyClass
                                          company =
                                              companies[index];
                                          return CompanyTile(
                                            company:
                                                company,
                                          );
                                        },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
              switchAction(false);
            },
          ),
        ),
      ],
    );
  }
}

class CompanyTile extends StatefulWidget {
  const CompanyTile({super.key, required this.company});

  final CompanyClass company;

  @override
  State<CompanyTile> createState() => _CompanyTileState();
}

class _CompanyTileState extends State<CompanyTile> {
  bool isOpen = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            title: Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  size: 20,
                  color: returnTheme(
                    context,
                  ).primaryLight(),
                  Icons.home_work_outlined,
                ),
                Text(
                  style: TextStyle(
                    fontSize: 13,
                    color: returnTheme(context).darkGrey(),
                  ),
                  widget.company.name,
                ),
              ],
            ),
            trailing: Icon(
              size: 23,
              color: returnTheme(context).darkMediumGrey(),
              !isOpen
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
            ),
          ),
          Visibility(
            visible: isOpen,
            child: Column(
              children: [
                Divider(
                  height: 10,
                  indent: 30,
                  endIndent: 30,
                  thickness: 0.1,
                  color: returnTheme(
                    context,
                  ).darkMediumGrey(),
                ),
                SizedBox(height: 5),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: returnTheme(
                          context,
                        ).darkMediumGrey(),
                      ),
                      'Are you sure you want to send this company a Request?',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        spacing: 10,
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              showShadow: false,
                              action: () {
                                setState(() {
                                  isOpen = false;
                                });
                              },
                              title: 'Cancel',
                            ),
                          ),
                          Expanded(
                            child: MainButton(
                              showShadow: false,
                              loadingWidget: !isLoading
                                  ? null
                                  : SizedBox(
                                      height: 20,
                                      width: 20,
                                      child:
                                          CircularProgressIndicator(
                                            color: Colors
                                                .white,
                                            strokeWidth:
                                                1.5,
                                          ),
                                    ),
                              action: () async {
                                setState(() {
                                  isLoading = !isLoading;
                                });
                                await RequestsProvider()
                                    .createRequest(
                                      RequestClass(
                                        userId: AuthService()
                                            .currentUser!
                                            .id,
                                        companyId: widget
                                            .company
                                            .id!,
                                      ),
                                    );
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Home();
                                      },
                                    ),
                                  );
                                }
                              },
                              title: 'Proceed',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 30,
                  thickness: 0.1,
                  color: returnTheme(
                    context,
                  ).darkMediumGrey(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreateCustomerForm extends StatefulWidget {
  final Function()? action;
  final Function(bool value) switchAction;
  const CreateCustomerForm({
    super.key,
    this.action,
    required this.switchAction,
  });

  @override
  State<CreateCustomerForm> createState() =>
      _CreateCustomerFormState();
}

class _CreateCustomerFormState
    extends State<CreateCustomerForm> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  Future<void> createCompany() async {
    if (_formKey.currentState!.validate()) {
      widget.switchAction(true);
      var res = await CompanyProvider().createCompany(
        CompanyClass(
          name: nameController.text.trim(),
          desc: descController.text,
          email: emailController.text.isNotEmpty
              ? emailController.text
              : AuthService().currentUser!.email,
        ),
      );
      if (res == null) {
        widget.switchAction(false);
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return ErrorAlert(
              message:
                  'An error occoured while trying Create Your Company Account. Please check your credentials and Network and try again.',
              title: 'Error Creating Company',
            );
          },
        );
      } else {
        print('Company Created Successfully');
        var userRes = await UserProvider().updateUser(
          UserClass(
            id: UserProvider().currentUser!.id!,
            name: UserProvider().currentUser!.name,
            email: UserProvider().currentUser!.email,
            createdAt:
                UserProvider().currentUser!.createdAt,
            isAdmin: true,
            companyId: res.id,
          ),
        );
        if (userRes != null) {
          print('User Update Success');
        } else {
          print('User Update Failed');
        }
        widget.switchAction(false);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Home();
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
  TextEditingController descController =
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
            'Create Company',
          ),
          Text(
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            'Enter Company Details to create yout company account',
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
            title: 'Company Name',
          ),
          SizedBox(height: 5),
          EmailTextField(
            emailController: emailController,
            isOptional: true,
          ),
          SizedBox(height: 5),
          NormalTextfield(
            numberOfLines: 3,
            inputController: descController,
            hintText: 'Enter Description',
            isOptional: true,
            title: 'Company Description',
          ),
          SizedBox(height: 5),
          SizedBox(height: 10),
          MainButton(
            title: 'Create Company',
            action: () async {
              await createCompany();
            },
          ),
          SizedBox(height: 7),
          InkWell(
            onTap: () async {
              await AuthService().signOut(context: context);
            },
            child: Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
              'Are you an employee? Request to be added to a company.',
            ),
          ),
          SizedBox(height: 7),
          SecondaryButton(
            action: widget.action,
            title: 'Select A Company',
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:promas/components/buttons/main_button.dart';
// import 'package:promas/components/buttons/secondary_button.dart';
// import 'package:promas/components/sections/heading_section.dart';
// import 'package:promas/constants/general_constants.dart';
// import 'package:promas/main.dart';

// class ConfirmAlert extends StatefulWidget {
//   final String buttonText;
//   final Function() action;
//   final String subText;
//   final String? title;
//   final bool? isLoading;
//   const ConfirmAlert({
//     super.key,
//     required this.buttonText,
//     required this.action,
//     required this.subText,
//     this.isLoading,
//     this.title,
//   });

//   @override
//   State<ConfirmAlert> createState() => _ConfirmAlertState();
// }

// class _ConfirmAlertState extends State<ConfirmAlert> {
//   bool isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       insetPadding: EdgeInsets.symmetric(horizontal: 15),
//       backgroundColor: returnTheme(
//         context,
//         listen: false,
//       ).containerColor(),
//       contentPadding: EdgeInsets.all(10),
//       shape: OutlineInputBorder(
//         borderRadius: mainBorderRadius,
//         borderSide: BorderSide(
//           color: Colors.transparent,
//           width: 0,
//         ),
//       ),
//       content: Container(
//         padding: EdgeInsets.symmetric(
//           vertical: 25,
//           horizontal: 15,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             spacing: 5,
//             children: [
//               HeadingSection(
//                 subText: widget.subText,
//                 title:
//                     widget.title ?? 'Proceed With Action?',
//               ),
//               SizedBox(height: 10),
//               Column(
//                 spacing: 7,
//                 children: [
//                   MainButton(
//                     action: () async {
//                       setState(() {
//                         isLoading = true;
//                       });
//                       widget.action();
//                       await Future.delayed(
//                         Duration(seconds: 3),
//                       );
//                       setState(() {
//                         isLoading = false;
//                       });
//                     },
//                     title: widget.buttonText,
//                     loadingWidget: isLoading,
//                   ),
//                   SecondaryButton(
//                     title: 'Cancel',
//                     action: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

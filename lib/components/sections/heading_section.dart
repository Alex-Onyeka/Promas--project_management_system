import 'package:flutter/material.dart';

class HeadingSection extends StatelessWidget {
  final String title;
  final String subText;
  final Color? color;
  final Function()? action;
  const HeadingSection({
    super.key,
    required this.title,
    required this.subText,
    this.color,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: 0,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.clear),
              ),
            ),
            Text(
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              title,
            ),
            IconButton(
              onPressed: () {
                action != null
                    ? action!()
                    : Navigator.of(context).pop();
              },
              icon: Icon(Icons.clear),
            ),
          ],
        ),
        Container(
          height: 2,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color ?? Colors.blue,
          ),
        ),
        SizedBox(height: 5),
        Text(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
          ),
          subText,
        ),
      ],
    );
  }
}

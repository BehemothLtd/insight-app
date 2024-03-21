import 'package:flutter/material.dart';

class AuthDividerWithText extends StatelessWidget {
  final String text;
  final double fontSize;

  const AuthDividerWithText({
    super.key,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: (size.width - 250) * 0.5,
            color: const Color.fromARGB(70, 136, 136, 136),
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: fontSize, color: const Color(0xff888888)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: (size.width - 250) * 0.5,
            color: const Color.fromARGB(70, 136, 136, 136),
          ),
        ),
      ],
    );
  }
}

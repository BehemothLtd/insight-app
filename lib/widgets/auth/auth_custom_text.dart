import 'package:flutter/material.dart';

class AuthCustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const AuthCustomText({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: padding ?? const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: fontSize == 22 ? FontWeight.w700 : FontWeight.w400,
          color: color,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

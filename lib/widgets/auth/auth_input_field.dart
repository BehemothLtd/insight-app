import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class AuthInputField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final Color textColor;
  final double fontSize;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? padding;
  final String hintText;

  const AuthInputField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.controller,
    required this.textColor,
    required this.fontSize,
    this.padding,
    this.hintText = "",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: textColor,
              fontSize: fontSize,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: padding ?? const EdgeInsets.only(bottom: 2),
          child: TextField(
            style: const TextStyle(fontSize: 14),
            obscureText: obscureText,
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Color(0xff8280B4)),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              focusedBorder: const GradientOutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                  colors: [Color(0xff38B1A6), Color(0xff434C9D)],
                ),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

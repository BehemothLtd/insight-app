import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;
  final String? svgPath;
  final bool disabled;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.svgPath,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.all(0),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 40.0,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: const LinearGradient(
              colors: [
                Color(0XFF38B1A6),
                Color(0XFF434C9D),
              ],
            ),
          ),
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (svgPath != null) SvgPicture.asset(svgPath!),
              const SizedBox(width: 8.0),
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: disabled
                      ? const Color.fromARGB(255, 211, 211, 211)
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

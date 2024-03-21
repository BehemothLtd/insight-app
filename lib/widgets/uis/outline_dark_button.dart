import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutlineDarkButton extends StatelessWidget {
  final Function() onPressed;
  final String? svgPath;
  final String buttonText;

  const OutlineDarkButton({
    Key? key,
    required this.onPressed,
    this.svgPath,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.all(0),
          side: const BorderSide(color: Color(0xff8280B4)),
          elevation: 0,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
          ),
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (svgPath != null) SvgPicture.asset(svgPath!),
              const SizedBox(width: 8.0),
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

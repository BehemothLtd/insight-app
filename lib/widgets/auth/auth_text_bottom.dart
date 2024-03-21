import 'package:flutter/material.dart';

class AuthTextBottom extends StatelessWidget {
  final String questionText;
  final String signUpText;
  final Function()? onPressed;

  const AuthTextBottom({
    Key? key,
    required this.questionText,
    required this.signUpText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            questionText,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              signUpText,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

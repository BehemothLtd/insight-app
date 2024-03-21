import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final String backgroundImage;
  final double imageWidthFactor;

  const AuthBackground({
    Key? key,
    required this.child,
    required this.backgroundImage,
    this.imageWidthFactor = 0.25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double leftPosition =
        (size.width - (size.width * 0.2)) / 2 - (size.width * imageWidthFactor);

    EdgeInsets padding = EdgeInsets.only(
        top: size.height * 0.396995708155, left: 24, right: 24, bottom: 24);

    return ListView(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: size.height * 0.0568669527897,
              left: leftPosition,
              child: Image.asset(
                backgroundImage,
                width: size.width * 0.767441860465,
                height: size.height * 0.287553648069,
              ),
            ),
            Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  child,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/models/user.dart';

class UserCircleAvatar extends StatelessWidget {
  final double size;

  const UserCircleAvatar({
    super.key,
    required this.user,
    this.size = 35,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: LightColors.kBlue,
      radius: size,
      child: ClipOval(
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/avatar.png',
          image: user?.avatarUrl ?? '',
          fit: BoxFit.cover,
          width: 70.0,
          height: 70.0,
          fadeInDuration: const Duration(milliseconds: 200),
          fadeOutDuration: const Duration(milliseconds: 100),
          placeholderErrorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/avatar.png');
          },
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/avatar.png');
          },
        ),
      ),
    );
  }
}

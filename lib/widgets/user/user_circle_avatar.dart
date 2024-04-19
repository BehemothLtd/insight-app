import 'package:flutter/material.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/utils/constants.dart';

class UserCircleAvatar extends StatelessWidget {
  final double size;
  final User? user;

  const UserCircleAvatar({
    super.key,
    required this.user,
    this.size = 35,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = user?.avatarUrl ?? defaultUserImage();
    bool isNetworkUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return CircleAvatar(
      backgroundColor: LightColors.kBlue,
      radius: size,
      child: ClipOval(
        child: isNetworkUrl
            ? Image.network(
                imageUrl,
                width: size * 2,
                height: size * 2,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(imageUrl); // Fallback local asset
                },
              )
            : Image.asset(
                imageUrl,
                width: 70.0,
                height: 70.0,
                fit: BoxFit.cover,
              ), // Fallback for local images
      ),
    );
  }
}

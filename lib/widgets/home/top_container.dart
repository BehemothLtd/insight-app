import 'package:flutter/material.dart';

import 'package:insight_app/widgets/uis/top_container.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/theme/colors/light_colors.dart';

class HomePageTopContainer extends StatelessWidget {
  const HomePageTopContainer({
    super.key,
    required this.width,
    required this.currentUser,
  });

  final double width;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return TopContainer(
      height: 200,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.menu,
                color: LightColors.kDarkBlue,
                size: 30.0,
              ),
              Icon(
                Icons.search,
                color: LightColors.kDarkBlue,
                size: 25.0,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: LightColors.kBlue,
                  radius: 35.0,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder:
                          'assets/images/placeholder-avatar.png', // Local asset placeholder
                      image: currentUser?.avatarUrl ?? '',
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      currentUser?.fullName ?? '',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 22.0,
                        color: LightColors.kDarkBlue,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      currentUser?.email ?? '',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

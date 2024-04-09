import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:insight_app/widgets/uis/top_container.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/theme/colors/light_colors.dart';

class HomePageTopContainer extends StatelessWidget {
  const HomePageTopContainer({
    super.key,
    required this.width,
    required this.currentUser,
    required this.onMenuTap,
  });

  final double width;
  final User? currentUser;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return TopContainer(
      height: 200,
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: onMenuTap,
                  icon: const Icon(
                    Icons.menu,
                    color: LightColors.kDarkBlue,
                    size: 30.0,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: LightColors.kBlue,
                  radius: 35.0,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder-avatar.png',
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
              ],
            ),
            const SizedBox(
                height: 20), // Provide space between the row and the text
            Text(
              currentUser?.fullName ?? '',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 22.0,
                  color: LightColors.kDarkBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              currentUser?.email ?? '',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black45,
                fontWeight: FontWeight.w400,
              ),
            ),
            // You can add additional content here if needed
          ],
        ),
      ),
    );
  }
}

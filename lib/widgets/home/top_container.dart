import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:insight_app/widgets/uis/top_container.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/widgets/user/circle_avatar.dart';

class HomeScreenTopContainer extends StatelessWidget {
  const HomeScreenTopContainer({
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
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(
                      Icons.menu,
                      color: LightColors.kDarkBlue,
                      size: 30.0,
                    ),
                  );
                }),
                UserCircleAvatar(user: currentUser),
              ],
            ),
            const SizedBox(
              height: 20,
            ), // Provide space between the row and the text
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

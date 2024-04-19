import 'package:flutter/material.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/widgets/user/user_circle_avatar.dart';

class UsersAvatarGroup extends StatelessWidget {
  final List<User> users;
  final int max;
  final double avatarSize;

  const UsersAvatarGroup({
    super.key,
    required this.users,
    required this.max,
    this.avatarSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    int numberOfAvatarsToShow = users.length > max ? max : users.length;
    bool showMoreIndicator = users.length > max;

    List<User> displayUsers = users.reversed.toList();

    List<Widget> avatarWidgets = List.generate(numberOfAvatarsToShow, (index) {
      return Padding(
        padding: EdgeInsets.only(left: index * 20.0), // Overlap avatars
        child: UserCircleAvatar(user: displayUsers[index], size: avatarSize),
      );
    }).reversed.toList();

    if (showMoreIndicator) {
      avatarWidgets.add(
        Padding(
          padding: EdgeInsets.only(left: numberOfAvatarsToShow * 20.0),
          child: _buildMoreIndicator(users.length - max),
        ),
      );
    }

    return IntrinsicWidth(
      // Use IntrinsicWidth to fit the width to the content
      child: Stack(
        alignment: Alignment.centerLeft,
        children: avatarWidgets,
      ),
    );
  }

  Widget _buildMoreIndicator(int additionalCount) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      child: Text(
        '+$additionalCount',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

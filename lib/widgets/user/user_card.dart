import 'package:insight_app/constanst.dart';
import 'package:insight_app/models/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            // check user state to show color
            color: user.state == "active" ? Colors.blue[100] : Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserTypeIcon(user),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.fullName ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.name ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.email ?? "",
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (user.about != null || user.about != "")
                        const SizedBox(height: 10),
                      Text(
                        user.about ?? "",
                        style: const TextStyle(color: Colors.black54),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (user.about != null || user.about != "")
                        const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildUserCompanyLevel(user),
                                _buildUserRole(user),
                                _buildUserPosition(user),
                              ]),
                          Icon
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeIcon(User user) {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      radius: 35,
      child: ClipOval(
          child: FadeInImage.assetNetwork(
        placeholder: 'assets/images/no-image.jpg',
        image: user.avatarUrl ?? "",
        fit: BoxFit.cover,
        width: 70.0,
        height: 70.0,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholderErrorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/no-image.jpg');
        },
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/no-image.jpg');
        },
      )),
    );
  }

  Widget _buildUserCompanyLevel(User user) {
    var level = companyLevels.firstWhere(
      (l) => l["id"] == user.companyLevelId,
      orElse: () => {}, // Return null if no element satisfies the condition
    );

    if (level == {}) {
      return Container();
    }

    Color color = level["color"] as Color;
    String title = level["title"] as String;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 6.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.assignment_ind, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ],
        ));
  }

  Widget _buildUserRole(User user) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 6.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: user.state == 'active'
              ? Colors.green
              : Colors.blue, // Choose color based on project type
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.business, size: 16),
            const SizedBox(width: 4),
            Text(
              user.state!
                  .toUpperCase(), // Display the project type in uppercase
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ],
        ));
  }

  Widget _buildUserPosition(User user) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 6.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 4.0,
        ),
        decoration: BoxDecoration(
          color: user.state == 'active'
              ? Colors.green
              : Colors.blue, // Choose color based on project type
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.business, size: 16),
            const SizedBox(width: 4),
            Text(
              user.state!
                  .toUpperCase(), // Display the project type in uppercase
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ],
        ));
  }
}

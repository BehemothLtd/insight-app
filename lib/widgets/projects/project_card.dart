import 'package:flutter/material.dart';

import 'package:insight_app/models/project.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/utils/constants.dart';
import 'package:insight_app/widgets/user/users_avatar_group.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, User> uniqueUserMap = {};

    for (var assignee in project.projectAssignees ?? []) {
      if (assignee.user.id != null) {
        uniqueUserMap[assignee.user.id.toString()] = assignee.user;
      }
    }

    List<User> uniqueUsers = uniqueUserMap.values.toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: project.state == "active"
                ? Colors.green[100]
                : Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectTypeIcon(project),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              project.name ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              project.code ?? "",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: project.projectType == 'scrum'
                                    ? Colors.green
                                    : Colors
                                        .blue, // Choose color based on project type
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                project.projectType!
                                    .toUpperCase(), // Display the project type in uppercase
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project.description ?? "",
                    style: const TextStyle(color: Colors.black54),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 20,
            child: UsersAvatarGroup(
              users: uniqueUsers,
              max: 3,
              avatarSize: 23,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectTypeIcon(Project project) {
    String imageUrl = project.logoUrl ?? defaultNoImage();

    bool isNetworkUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return CircleAvatar(
      backgroundColor: Colors.blue,
      radius: 35,
      child: ClipOval(
        child: isNetworkUrl
            ? Image.network(
                imageUrl,
                width: 70.0,
                height: 70.0,
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
              ),
      ),
    );
  }
}

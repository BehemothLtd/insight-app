import 'package:flutter/material.dart';

import 'package:insight_app/models/project.dart';
import 'package:insight_app/models/user.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
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
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: _buildProjectTypeIcon(project.projectType!),
                      ),
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
                              style: const TextStyle(color: Colors.black54),
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

  Widget _buildProjectTypeIcon(String projectType) {
    IconData iconData =
        projectType == "scrum" ? Icons.check_circle_outline : Icons.view_kanban;
    Color iconColor =
        projectType == "scrum" ? Colors.blueAccent : Colors.deepOrange;
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Icon(iconData, color: iconColor),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:insight_app/models/project.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/widgets/user/circle_avatar.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Card(
        elevation: 2, // Adjust the elevation as needed
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: project.state == "active" ? Colors.teal[100] : Colors.grey[300],
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              project.name ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              project.code ?? "",
              style: const TextStyle(color: Colors.black54),
            ),
            leading: _buildProjectTypeIcon(project.projectType!),
            children: <Widget>[
              if (project.description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(project.description!),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Wrap(
                  spacing: 5.0, // Spacing between each avatar
                  children: uniqueUsers
                      .map((user) => Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: UserCircleAvatar(
                              user: user,
                              size: 20,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
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

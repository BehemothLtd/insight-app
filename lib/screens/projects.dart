import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/controllers/project_controller.dart';
import 'package:insight_app/widgets/projects/project_card.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectController = Get.put(ProjectController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (projectController.projects.value?.isEmpty ?? true) {
        projectController.fetchProjects();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      // RefreshIndicator can be used for pull-to-refresh functionality
      body: RefreshIndicator(
        onRefresh: () async {
          await projectController.fetchProjects();
        },
        child: Obx(() {
          var projects = projectController.projects.value;

          if (projects == null || projects.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          // Using ListView.separated can be beneficial for performance
          // and adds built-in separators for a cleaner design.
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return ProjectCard(project: projects[index]);
            },
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:insight_app/controllers/project_controller.dart';

class ProjectsFilter extends StatelessWidget {
  const ProjectsFilter({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.projectTypeController,
    required this.stateController,
    required this.projectController,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController projectTypeController;
  final TextEditingController stateController;
  final ProjectController projectController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Search"),
      content: SingleChildScrollView(
        // Ensures the dialog is scrollable on small devices
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) =>
                    projectController.projectsQuery.value?.nameCont = value,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => projectController
                    .projectsQuery.value?.descriptionCont = value,
              ),
              DropdownButtonFormField<String>(
                value: projectTypeController.text.isNotEmpty
                    ? projectTypeController.text
                    : null,
                decoration: const InputDecoration(labelText: 'Project Type'),
                onChanged: (value) {
                  projectTypeController.text = value ?? '';
                  projectController.projectsQuery.value?.projectTypeEq = value!;
                },
                items: const [
                  DropdownMenuItem(value: null, child: Text('Both')),
                  DropdownMenuItem(value: 'scrum', child: Text('Scrum')),
                  DropdownMenuItem(value: 'kanban', child: Text('Kanban')),
                ],
              ),
              DropdownButtonFormField<String>(
                value: stateController.text.isNotEmpty
                    ? stateController.text
                    : null,
                decoration: const InputDecoration(labelText: 'State'),
                onChanged: (value) {
                  stateController.text = value ?? '';
                  projectController.projectsQuery.value?.stateEq = value!;
                },
                items: const [
                  DropdownMenuItem(value: null, child: Text('Both')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            projectController.resetPagy();
            projectController.fetchProjects(true);
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
}

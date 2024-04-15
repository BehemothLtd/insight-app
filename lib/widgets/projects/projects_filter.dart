import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/controllers/project_controller.dart';

class ProjectsFilter extends StatefulWidget {
  const ProjectsFilter({
    super.key,
  });

  @override
  State<ProjectsFilter> createState() => _ProjectsFilterState();
}

class _ProjectsFilterState extends State<ProjectsFilter> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController projectTypeController;
  late TextEditingController stateController;

  final projectController = Get.put(ProjectController());

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
        text: projectController.projectsQuery.value?.nameCont);
    descriptionController = TextEditingController(
        text: projectController.projectsQuery.value?.descriptionCont);
    projectTypeController = TextEditingController(
        text: projectController.projectsQuery.value?.projectTypeEq);
    stateController = TextEditingController(
        text: projectController.projectsQuery.value?.stateEq);
  }

  @override
  Widget build(BuildContext context) {
    final projectController = Get.find<ProjectController>();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16), // Rounded corners for the AlertDialog
      ),
      title: const Text(
        "Search",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        24.0,
        24.0,
        24.0,
        0,
      ), // Consistent padding
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 20.0,
      ), // Consistent padding
      content: SingleChildScrollView(
        // Ensures the dialog is scrollable on small devices
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    projectController.projectsQuery.update((val) {
                      val?.nameCont = value;
                    });
                  }),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => projectController
                    .projectsQuery.value?.descriptionCont = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: projectTypeController.text.isNotEmpty
                    ? projectTypeController.text
                    : null,
                decoration: InputDecoration(
                  labelText: 'Project Type',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  projectTypeController.text = value ?? '';
                  projectController.projectsQuery.value?.projectTypeEq =
                      value ?? '';
                },
                items: const [
                  DropdownMenuItem(value: null, child: Text('Both')),
                  DropdownMenuItem(value: 'scrum', child: Text('Scrum')),
                  DropdownMenuItem(value: 'kanban', child: Text('Kanban')),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: stateController.text.isNotEmpty
                    ? stateController.text
                    : null,
                decoration: InputDecoration(
                  labelText: 'State',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  stateController.text = value ?? '';
                  projectController.projectsQuery.value?.stateEq = value ?? '';
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
          child: Text(
            'Search',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

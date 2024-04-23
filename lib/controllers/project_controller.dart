import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:insight_app/models/metadata.dart';
import 'package:insight_app/models/pagy_input.dart';

import 'package:insight_app/models/project.dart';
import 'package:insight_app/models/projects_query.dart';

class ProjectController extends GetxController {
  var projects = Rxn<List<Project>>([]);
  var input = Rxn<PagyInput>(PagyInput(page: 1, perPage: 10));
  var metadata = Rxn<Metadata>(null);
  var projectsQuery = Rxn<ProjectsQuery>(ProjectsQuery());

  setInput(value) {
    input.value = value;
  }

  setMetadata(value) {
    metadata.value = value;
  }

  increasePage() {
    input.value?.page = (input.value!.page + 1);
  }

  resetPagy() {
    input.value = PagyInput(perPage: 10, page: 1);
    metadata.value = null;
  }

  resetParams() {
    projectsQuery.value = ProjectsQuery();
  }

  fetchProjects(bool isRefresh) async {
    if (input.value != null && metadata.value != null) {
      var maxPages = metadata.value?.pages ?? 10;
      if (input.value!.page > maxPages) {
        return Future.error('No more projects to load');
      }
    }

    var result = await Project.fetchProjects(input.value, projectsQuery.value);

    if (result != null) {
      var list = result['list'];

      Metadata metadata = result['metadata'];

      setMetadata(metadata);
      setInput(
        PagyInput(
          perPage: metadata.perPage ?? 1,
          page: metadata.page ?? 10,
        ),
      );

      if (isRefresh) {
        projects.value = result['list'];
      } else {
        if (projects.value != null) {
          projects.value = [...projects.value!, ...list];
        } else {
          projects.value = list;
        }
      }
    }
  }
}

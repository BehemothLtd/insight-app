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
  var loading = RxBool(false);

  appendProjects(List<Project> newProjects, bool resetProjects) {
    if (resetProjects) {
      projects.value = null;
    }

    if (projects.value == null) {
      projects.value = newProjects;
    } else {
      projects.value = [...projects.value!, ...newProjects];
    }
  }

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
    resetPagy();
    projectsQuery.value = null;
  }

  setQuery({String? nameCont}) {
    if (nameCont != null) {
      projectsQuery.value!.nameCont = nameCont;
    }
  }

  fetchProjects([bool resetProjects = false]) async {
    loading.value = true;

    if (input.value != null && metadata.value != null) {
      var maxPages = metadata.value?.pages ?? 10;
      if (input.value!.page > maxPages) {
        return Future.error('No more projects to load');
      }
    }

    var result = await Project.fetchProjects(input.value, projectsQuery.value);

    loading.value = false;
    if (result != null) {
      appendProjects(result['list'], resetProjects);

      Metadata metadata = result['metadata'];

      setMetadata(metadata);
      setInput(
        PagyInput(
          perPage: metadata.perPage ?? 1,
          page: metadata.page ?? 10,
        ),
      );
    }
  }
}

import 'package:get/get.dart';
import 'package:insight_app/models/project.dart';

class ProjectController extends GetxController {
  var projects = Rxn<List<Project>>([]);

  setProjects(value) {
    projects.value = value;
  }

  fetchProjects() async {
    var result = await Project.fetchProjects();

    if (result != null) {
      setProjects(result['list']);
    }
  }
}

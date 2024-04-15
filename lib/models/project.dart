import 'package:get/get.dart';
import 'package:insight_app/models/metadata.dart';
import 'package:insight_app/models/pagy_input.dart';

import 'package:insight_app/models/project_assignee.dart';
import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/models/projects_query.dart';
import 'package:insight_app/utils/api.dart';

class Project {
  BigInt? id;
  String? name;
  String? code;
  String? description;
  String? projectType;
  String? state;
  DateTime? activedAt;
  DateTime? inactivedAt;
  DateTime? startedAt;
  DateTime? endedAt;
  List<ProjectAssignee>? projectAssignees;
  String? logoUrl;

  Project({
    this.id,
    this.name,
    this.code,
    this.description,
    this.projectType,
    this.state,
    this.projectAssignees,
    this.logoUrl,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    List<ProjectAssignee> projectAssignees = [];

    if (json['projectAssignees'] != null) {
      for (var projectAssignee in json['projectAssignees']) {
        projectAssignees.add(ProjectAssignee.fromJson(projectAssignee));
      }
    }

    return Project(
      id: BigInt.parse(json['id']),
      name: json['name'],
      code: json['code'],
      description: json['description'],
      projectType: json['projectType'],
      state: json['state'],
      logoUrl: json['logoUrl'],
      projectAssignees: projectAssignees,
    );
  }

  static fetchProjects(PagyInput? input, ProjectsQuery? projectsQuery) async {
    const query = gql.projectsListGQL;

    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var variables = {
      'input': input?.toJson() ?? {},
      'query': projectsQuery?.toJson() ?? {},
    };

    var result = await apiProvider.request(query: query, variables: variables);

    if (result != null) {
      var collection = result['Projects']['collection'];

      var projects =
          collection.map<Project>((json) => Project.fromJson(json)).toList();

      var metadata = Metadata.fromJson(
          result['Projects']['metadata'] as Map<String, dynamic>);

      return {
        'list': projects,
        'metadata': metadata,
      };
    }
  }
}

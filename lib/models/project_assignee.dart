import 'package:insight_app/models/user.dart';

class ProjectAssignee {
  User user;

  ProjectAssignee({
    required this.user,
  });

  factory ProjectAssignee.fromJson(Map<String, dynamic> json) {
    return ProjectAssignee(user: User.fromJson(json['user']));
  }
}

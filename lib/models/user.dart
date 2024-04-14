import 'package:get/get.dart';

import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/utils/api.dart';

class User {
  BigInt? id;
  String? email;
  String? name;
  String? fullName;
  int? issuesCount;
  int? projectsCount;
  String? avatarUrl;

  User({
    this.id,
    this.email,
    this.name,
    this.fullName,
    this.issuesCount = 0,
    this.projectsCount = 0,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: BigInt.parse(json['id']),
      email: json['email'],
      name: json['name'],
      fullName: json['fullName'],
      issuesCount: json['issuesCount'],
      projectsCount: json['projectsCount'],
      avatarUrl: json['avatarUrl'],
    );
  }

  static fetchSelfGeneralInfo() async {
    const query = gql.selfGeneralInfoGQL;
    final ApiProvider apiProvider = Get.find<ApiProvider>();

    User? user;

    var result = await apiProvider.request(query: query, variables: {});

    if (result != null) {
      user = User.fromJson(result['SelfGeneralInfo']);
    } else {
      user = null;
    }

    return user;
  }

  static signIn(String email, String password) async {
    const query = gql.signInGQL;
    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var result = await apiProvider.request(query: query, variables: {
      "email": email,
      "password": password,
    });

    if (result != null) {
      return result;
    }

    return null;
  }
}

import 'package:get/get.dart';

import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/models/pagy_input.dart';
import 'package:insight_app/models/users_query.dart';
import 'package:insight_app/utils/api.dart';
import 'package:insight_app/utils/time.dart';
import 'package:insight_app/models/metadata.dart';

class User {
  BigInt? id;
  String? email;
  String? name;
  String? fullName;
  int? issuesCount;
  int? projectsCount;
  String? avatarUrl;
  DateTime? birthday;
  String? gender;
  String? phone;
  String? address;
  String? slackId;
  String? about;
  String? state;

  User(
      {this.id,
      this.email,
      this.name,
      this.fullName,
      this.issuesCount = 0,
      this.projectsCount = 0,
      this.avatarUrl,
      this.gender,
      this.phone,
      this.address,
      this.slackId,
      this.about,
      this.birthday,
      this.state});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: BigInt.parse(json['id']),
      email: json['email'],
      name: json['name'],
      fullName: json['fullName'],
      issuesCount: json['issuesCount'],
      projectsCount: json['projectsCount'],
      avatarUrl: json['avatarUrl'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      slackId: json['slackId'],
      about: json['about'],
      birthday: json['birthday'] != null
          ? formatDateFromDDMMYYYY(json['birthday'])
          : null,
      state: json["state"],
    );
  }

  static Future<User?> fetchSelfGeneralInfo() async {
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

  static fetchProfile() async {
    const query = gql.selfProfileGQL;
    final ApiProvider apiProvider = Get.find<ApiProvider>();

    User? user;

    var result = await apiProvider.request(query: query, variables: {});

    if (result != null) {
      user = User.fromJson(result['SelfProfile']);
    }

    return user;
  }

  static fetchPermissions() async {
    const query = gql.selfPermissionGQL;
    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var result = await apiProvider.request(query: query, variables: {});

    if (result != null) {
      var permissionsJson = result['SelfPermission'];

      var permissions = permissionsJson
          .map<SelfPermission>((json) => SelfPermission.fromJson(json))
          .toList();

      return permissions;
    } else {
      return null;
    }
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

  static Future<User?> updateProfile(SelfUpdateProfileInput input) async {
    const query = gql.selfUpdateProfileGQL;
    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var result = await apiProvider.request(query: query, variables: {
      "input": input.toJson(),
    });

    if (result != null) {
      return User.fromJson(result['SelfUpdateProfile']['user']);
    }

    return null;
  }

  static fetchUsers(PagyInput? input, UsersQuery? usersQuery) async {
    const query = gql.usersListGQL;
    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var variables = {
      "input": input?.toJson() ?? {},
      "query": usersQuery?.toJson() ?? {}
    };

    var result = await apiProvider.request(query: query, variables: variables);

    if (result != null) {
      var collection = result["Users"]["collection"];

      var users = collection.map<User>((json) => User.fromJson(json)).toList();

      var metadata = Metadata.fromJson(
          result["Users"]["metadata"] as Map<String, dynamic>);

      return {"list": users, "metadata": metadata};
    }
  }
}

class SelfUpdateProfileInput {
  String about;
  String slackId;
  String address;
  String phone;
  String fullName;
  String birthday;
  String gender;
  String avatarKey;

  SelfUpdateProfileInput({
    this.fullName = "",
    this.about = "",
    this.slackId = "",
    this.address = "",
    this.phone = "",
    this.birthday = "",
    this.gender = "",
    this.avatarKey = "",
  });

  Map<String, dynamic> toJson() => {
        'about': about,
        'slackId': slackId,
        'address': address,
        'phone': phone,
        'fullName': fullName,
        'birthday': birthday,
        'gender': gender,
        'avatarKey': avatarKey,
      };
}

class SelfPermission {
  BigInt? id;
  String? action;
  String? target;

  SelfPermission({this.id, this.action, this.target});

  factory SelfPermission.fromJson(Map<String, dynamic> json) {
    return SelfPermission(
      id: BigInt.parse(json['id']),
      action: json['action'],
      target: json['target'],
    );
  }
}

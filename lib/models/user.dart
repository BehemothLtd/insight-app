import 'package:get/get.dart';

import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/utils/api.dart';
import 'package:insight_app/utils/time.dart';

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

  User({
    this.id,
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
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      slackId: json['slackId'],
      about: json['about'],
      birthday: json['birthday'] != null
          ? formatDateFromDDMMYYYY(json['birthday'])
          : null,
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
}

class SelfUpdateProfileInput {
  String about;
  String slackId;
  String address;
  String phone;
  String fullName;
  String birthday;
  String gender;

  SelfUpdateProfileInput({
    this.fullName = "",
    this.about = "",
    this.slackId = "",
    this.address = "",
    this.phone = "",
    this.birthday = "",
    this.gender = "",
  });

  Map<String, dynamic> toJson() => {
        'about': about,
        'slackId': slackId,
        'address': address,
        'phone': phone,
        'fullName': fullName,
        'birthday': birthday,
        'gender': gender,
      };
}

import 'package:get/get.dart';

import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/utils/api.dart';

class Attendance {
  DateTime? checkinAt;
  DateTime? checkoutAt;
  DateTime createdAt;

  Attendance({
    this.checkinAt,
    this.checkoutAt,
    required this.createdAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      checkinAt:
          json['checkinAt'] != null ? DateTime.parse(json['checkinAt']) : null,
      checkoutAt: json['checkoutAt'] != null
          ? DateTime.parse(json['checkoutAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static fetchSelfAttendances() async {
    const query = gql.selfAttendancesGQL;

    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var result = await apiProvider
        .request(query: query, variables: {}); // TODO: add variables

    if (result != null) {
      var collection = result['SelfAttendances']['collection'] as List;
      var attendancesList = collection
          .map<Attendance>((json) => Attendance.fromJson(json))
          .toList();

      var metadata =
          result['SelfAttendances']['metadata'] as Map<String, dynamic>;

      return {
        'list': attendancesList,
        'metadata': metadata,
      };
    }
    return null;
  }

  static attend() async {
    const query = gql.selfAttendGQL;
    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var result = await apiProvider.request(query: query, variables: {});

    if (result != null) {
      print(result);
    }
  }
}

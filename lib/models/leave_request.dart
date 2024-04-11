import 'dart:ffi';

import 'package:get/get.dart';
import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/utils/api.dart';

class LeaveRequest {
  String? from;
  String? to;
  double? timeOff;
  String? requestType;
  String? description;

  LeaveRequest({
    required this.from,
    required this.to,
    required this.timeOff,
    required this.requestType,
    required this.description,
  });

  void request() async {
    const query = gql.leaveRequestCreateGQL;

    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var variables = {
      "input": {
        "from": from ?? "",
        "to": to ?? "",
        "timeOff": timeOff,
        "requestType": requestType ?? "",
        "description": description ?? "",
      }
    };

    await apiProvider.request(
      query: query,
      variables: variables,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/models/leave_requests_query.dart';
import 'package:insight_app/models/metadata.dart';
import 'package:insight_app/models/pagy_input.dart';
import 'package:insight_app/utils/api.dart';
import 'package:insight_app/utils/time.dart';

class LeaveRequest {
  BigInt? id;
  BigInt? userId;
  BigInt? approverId;
  DateTime? from;
  DateTime? to;
  double? timeOff;
  String? requestType;
  String? reason;
  String? requestState;

  LeaveRequest({
    this.id,
    this.userId,
    this.approverId,
    required this.from,
    required this.to,
    required this.timeOff,
    required this.requestType,
    required this.reason,
    this.requestState,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: BigInt.parse(json['id']),
      userId: BigInt.parse(json['userId']),
      approverId: json['approverId'] != null ? BigInt.parse(json['approverId']) : BigInt.zero,
      from: DateTime.tryParse(json['from']),
      to: DateTime.tryParse(json['to']),
      timeOff: json['timeOff'] is String ? double.parse(json['timeOff']) : 0.0,
      requestType: json['requestType'] ?? "",
      reason: json['reason'] ?? "",
      requestState: json['requestState'] ?? "",
    );
  }

  Future<dynamic> request() {
    const query = gql.leaveRequestCreateGQL;

    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var variables = {
      "input": {
        "from": formatTime(from, 'dd-MM-yyyy HH:mm'),
        "to": formatTime(to, 'dd-MM-yyyy HH:mm'),
        "timeOff": timeOff,
        "requestType": requestType ?? "",
        "reason": reason ?? "",
      }
    };

    return apiProvider.request(
      query: query,
      variables: variables,
    );
  }

  static fetchLeaveRequests(
      PagyInput? input, LeaveRequestsQuery? leaveRequestsQuery) async {
    const query = gql.leaveRequestsListGQL;

    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var variables = {
      "input": {
        "pagyInput": input?.toJson() ?? {},
        "leaveDayRequestsQuery": leaveRequestsQuery?.toJson() ?? {},
      }
    };

    var result = await apiProvider.request(query: query, variables: variables);

    if (result != null) {
      var collection = result['LeaveDayRequests']['collection'];

      var requests = collection
          .map<LeaveRequest>((json) => LeaveRequest.fromJson(json))
          .toList();

      var metadata = Metadata.fromJson(
          result['LeaveDayRequests']['metadata'] as Map<String, dynamic>);

      return {
        'list': requests,
        'metadata': metadata,
      };
    }
  }
}

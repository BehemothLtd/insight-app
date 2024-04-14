import 'package:get/get.dart';
import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/utils/api.dart';
import 'package:insight_app/utils/time.dart';

class LeaveRequest {
  DateTime? from;
  DateTime? to;
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

  Future<dynamic> request() {
    const query = gql.leaveRequestCreateGQL;

    final ApiProvider apiProvider = Get.find<ApiProvider>();

    var variables = {
      "input": {
        "from": formatTime(from, 'dd-MM-yyyy HH:mm'),
        "to": formatTime(to, 'dd-MM-yyyy HH:mm'),
        "timeOff": timeOff,
        "requestType": requestType ?? "",
        "description": description ?? "",
      }
    };

    return apiProvider.request(
      query: query,
      variables: variables,
    );
  }
}

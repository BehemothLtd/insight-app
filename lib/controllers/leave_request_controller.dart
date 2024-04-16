import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/models/metadata.dart';
import 'package:insight_app/models/pagy_input.dart';

import 'package:insight_app/models/leave_request.dart';
import 'package:insight_app/models/leave_requests_query.dart';

import 'package:insight_app/utils/custom_snackbar.dart';

class LeaveRequestController extends GetxController {
  Future<bool> createNewRequest(LeaveRequest leaveRequest) async {
    var result = await leaveRequest.request();

    if (result != null) {
      showCustomSnackbar(
        message: "Leave Request Submitted",
        title: 'Success',
        backgroundColor: Colors.blue,
        iconData: Icons.check,
      );

      return true;
    }

    return false;
  }

  var leaveRquests = Rxn<List<LeaveRequest>>([]);
  var input = Rxn<PagyInput>(PagyInput(page: 1, perPage: 10));
  var metadata = Rxn<Metadata>(null);
  var leaveRequestsQuery = Rxn<LeaveRequestsQuery>(LeaveRequestsQuery());

  fetchLeaveRquest(bool isRefresh) async {
    var result = await LeaveRequest.fetchLeaveRequests(
        input.value, leaveRequestsQuery.value);

    if (result != null) {
      leaveRquests.value = result["list"];
    }
  }
}

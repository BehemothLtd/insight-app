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

  Future<String?> approveLeaveRequest(
    LeaveRequestChangeStatusInput leaveRequestChangeStatusInput,
  ) async {
    var result =
        await LeaveRequest.approveLeaveRequest(leaveRequestChangeStatusInput);

    if (result != null) {
      showCustomSnackbar(
        message: "Leave Request Submitted",
        title: 'Success',
        backgroundColor: Colors.blue,
        iconData: Icons.check,
      );

      return result.requestState;
    }

    return "";
  }

  var leaveRquests = Rxn<List<LeaveRequest>>([]);
  var input = Rxn<PagyInput>(PagyInput(page: 1, perPage: 10));
  var metadata = Rxn<Metadata>(null);
  var leaveRequestsQuery = Rxn<LeaveRequestsQuery>(LeaveRequestsQuery());

  fetchLeaveRquests(bool isRefresh) async {
    if (input.value != null && metadata.value != null) {
      var maxPages = metadata.value?.pages ?? 10;
      if (input.value!.page > maxPages) {
        return Future.error('No more requests to load');
      }
    }

    var result = await LeaveRequest.fetchLeaveRequests(
        input.value ?? PagyInput(page: 1, perPage: 10),
        leaveRequestsQuery.value);

    if (result != null) {
      var list = result["list"];

      Metadata metadata = result["metadata"];

      setMetadata(metadata);
      setInput(
        PagyInput(
          perPage: metadata.perPage ?? 1,
          page: metadata.page ?? 10,
        ),
      );

      if (isRefresh) {
        leaveRquests.value = result["list"];
      } else {
        if (leaveRquests.value != null) {
          leaveRquests.value = [...leaveRquests.value!, ...list];
        } else {
          leaveRquests.value = list;
        }
      }
    }
  }

  setInput(value) {
    input.value = value;
  }

  setMetadata(value) {
    metadata.value = value;
  }

  increasePage() {
    input.value?.page = (input.value!.page + 1);
  }

  resetPagy() {
    input.value = PagyInput(perPage: 10, page: 1);
    metadata.value = null;
  }

  resetParams() {
    leaveRequestsQuery.value = LeaveRequestsQuery();
  }
}

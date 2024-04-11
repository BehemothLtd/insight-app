import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/models/leave_request.dart';
import 'package:insight_app/utils/custom_snackbar.dart';

class LeaveRequestController extends GetxController {
  createNewRequest(LeaveRequest leaveRequest) async {
    var result = await leaveRequest.request();

    if (result != null) {
      showCustomSnackbar(
        message: "Leave Request Submitted",
        title: 'Success',
        backgroundColor: Colors.blue,
        iconData: Icons.check,
      );
    }
  }
}

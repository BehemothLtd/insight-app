import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/models/attendance.dart';
import 'package:insight_app/utils/custom_snackbar.dart';

class AttendanceController extends GetxController {
  var selfAttendances = Rxn<List<Attendance>>();
  var selfAttendanceToday = Rxn<Attendance>();

  setSelfAttendances(value) {
    selfAttendances.value = value;
  }

  setSelfAttendanceToday(value) {
    selfAttendanceToday.value = value;
  }

  fetchSelfAttendances() async {
    var result = await Attendance.fetchSelfAttendances();

    if (result != null) {
      setSelfAttendances(result['list']);
    }
  }

  checkAttendanceToday() {
    DateTime now = DateTime.now();
    // Set the current time to midnight for comparison
    DateTime today = DateTime(now.year, now.month, now.day);

    var attendances = selfAttendances.value;

    if (attendances != null) {
      for (Attendance attendance in attendances) {
        DateTime checkInDate = attendance.checkinAt;

        if (checkInDate.year == today.year &&
            checkInDate.month == today.month &&
            checkInDate.day == today.day) {
          selfAttendanceToday(attendance);
        }
      }
    }

    return null;
  }

  bool get needToCheckIn => selfAttendanceToday.value == null;

  bool get checkedIn =>
      selfAttendanceToday.value != null &&
      selfAttendanceToday.value?.checkinAt != null &&
      selfAttendanceToday.value?.checkoutAt == null;

  bool get checkedOut =>
      selfAttendanceToday.value != null &&
      selfAttendanceToday.value?.checkinAt != null &&
      selfAttendanceToday.value?.checkoutAt != null;

  attend() async {
    String notiMessage = "";

    if (needToCheckIn) {
      notiMessage = "Checked In";
    } else if (checkedIn) {
      notiMessage = "Checked Out";
    }

    var result = await Attendance.attend();

    if (result) {
      showCustomSnackbar(
        message: notiMessage,
        title: 'Success',
        backgroundColor: Colors.blue,
        iconData: Icons.check,
      );

      await fetchSelfAttendances();
      checkAttendanceToday();
    }
  }
}

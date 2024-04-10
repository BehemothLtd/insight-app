import 'package:get/get.dart';

import 'package:insight_app/models/attendance.dart';

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
        if (attendance.checkinAt != null) {
          DateTime checkInDate = attendance.checkinAt!;
          if (checkInDate.year == today.year &&
              checkInDate.month == today.month &&
              checkInDate.day == today.day) {
            selfAttendanceToday(attendance);
          }
        }
      }
    }

    return null;
  }
}

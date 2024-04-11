import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:insight_app/controllers/attendance_controller.dart';
import 'package:insight_app/widgets/attendanceBox/checked_in.dart';
import 'package:insight_app/widgets/attendanceBox/check_in.dart';
import 'package:insight_app/widgets/attendanceBox/checked_out.dart';

class AttendanceBox extends StatefulWidget {
  const AttendanceBox({super.key});

  @override
  State<AttendanceBox> createState() => AttendanceBoxState();
}

class AttendanceBoxState extends State<AttendanceBox> {
  Future<void> refreshData() async {
    await attendanceController.fetchSelfAttendances();
    attendanceController.checkAttendanceToday();
  }

  final attendanceController = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();

    String formattedDate = DateFormat('MMM d, yyyy').format(currentDate);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await attendanceController.fetchSelfAttendances();
      attendanceController.checkAttendanceToday();
    });

    return Padding(
      padding: const EdgeInsets.all(20.0), // Adjust the padding as necessary.
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    height: 32,
                    thickness: 1,
                  ),
                  if (attendanceController.needToCheckIn)
                    const CheckIn()
                  else if (attendanceController.checkedIn)
                    CheckedIn(
                      attendance:
                          attendanceController.selfAttendanceToday.value,
                    )
                  else if (attendanceController.checkedOut)
                    CheckedOut(
                      attendance:
                          attendanceController.selfAttendanceToday.value,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

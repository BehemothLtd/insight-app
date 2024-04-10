import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:insight_app/controllers/attendance_controller.dart';
import 'package:insight_app/widgets/attendanceBox/checked_in.dart';
import 'package:insight_app/widgets/attendanceBox/check_in.dart';
import 'package:insight_app/widgets/attendanceBox/checked_out.dart';

class AttendanceBox extends StatelessWidget {
  const AttendanceBox({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final DateTime currentDate = DateTime.now();

    final attendanceController = Get.put(AttendanceController());
    String formattedDate = DateFormat('MMM d, yyyy').format(currentDate);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // This will be called after the widget's build method has finished
      await attendanceController.fetchSelfAttendances();
      attendanceController.checkAttendanceToday();
    });

    return Expanded(
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: width,
              child: Card(
                margin: const EdgeInsets.all(16.0),
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
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
                              attendance: attendanceController
                                  .selfAttendanceToday.value,
                            )
                          else if (attendanceController.checkedOut)
                            CheckedOut(
                              attendance: attendanceController
                                  .selfAttendanceToday.value,
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Handle "show more" action
                                },
                                child: const Text('Show more'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

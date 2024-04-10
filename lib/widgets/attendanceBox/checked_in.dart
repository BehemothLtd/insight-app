import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/controllers/attendance_controller.dart';
import 'package:insight_app/utils/time.dart';

import 'package:insight_app/models/attendance.dart';

class CheckedIn extends StatelessWidget {
  const CheckedIn({
    super.key,
    required this.attendance,
  });

  final Attendance? attendance;

  @override
  Widget build(BuildContext context) {
    // Format the dates to be more user-friendly
    String checkinTime = formatTime(attendance?.checkinAt, 'hh:mm a');

    final attendanceController = Get.put(AttendanceController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Checkin at',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            checkinTime,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Check Out',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    content: const Text('Are you sure you want to check out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .pop(), // Dismiss the dialog but do nothing
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Dismiss the dialog and perform the check-in action
                          Navigator.of(context).pop();
                          attendanceController.attend();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.logout,
              size: 24,
              color: Colors.white,
            ),
            label: const Text(
              "Check out",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}

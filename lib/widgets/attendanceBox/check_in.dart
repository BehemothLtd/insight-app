import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/controllers/attendance_controller.dart';

class CheckIn extends StatelessWidget {
  const CheckIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final attendanceController = Get.put(AttendanceController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You haven\'t checked in yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // attendanceController.attend();
              // Show the dialog here
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Row(
                      children: [
                        Icon(
                          Icons.login,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Check In',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    content: const Text('Are you sure you want to check in?'),
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
              Icons.login,
              color: Colors.white,
            ),
            label: const Text(
              'Check in',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
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

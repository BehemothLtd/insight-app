import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/controllers/attendance_controller.dart';

class NotCheckedIn extends StatelessWidget {
  const NotCheckedIn({
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
              attendanceController.attend();
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

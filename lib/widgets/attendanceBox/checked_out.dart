import 'package:flutter/material.dart';
import 'package:insight_app/utils/time.dart';

import 'package:insight_app/models/attendance.dart';

class CheckedOut extends StatelessWidget {
  const CheckedOut({
    super.key,
    required this.attendance,
  });

  final Attendance? attendance;

  @override
  Widget build(BuildContext context) {
    // Format the dates to be more user-friendly
    String checkinTime = formatTime(attendance?.checkinAt, 'hh:mm a');
    String checkoutTime = formatTime(attendance?.checkoutAt, 'hh:mm a');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
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
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Checkout at',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  checkoutTime,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

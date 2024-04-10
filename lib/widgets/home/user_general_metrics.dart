import 'package:flutter/material.dart';

import 'package:insight_app/widgets/uis/info_card.dart';
import 'package:insight_app/models/user.dart';

class UserGeneralMetrics extends StatelessWidget {
  final User? currentUser;

  const UserGeneralMetrics({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    // Same padding as the AttendanceBox
    return Padding(
      padding: const EdgeInsets.only(
        left: 22.0,
        right: 22.0,
        top: 30,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InfoCard(
              title: 'Projects',
              value: '${currentUser?.projectsCount}',
              icon: Icons.work,
              iconBackgroundColor: Colors.blue,
            ),
          ),
          const SizedBox(width: 16), // Space between the cards
          Expanded(
            child: InfoCard(
              title: 'Issues',
              value: '${currentUser?.issuesCount}',
              icon: Icons.task,
              iconBackgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

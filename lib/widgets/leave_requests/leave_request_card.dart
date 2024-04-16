import 'package:flutter/material.dart';
import 'package:insight_app/models/leave_request.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest leaveRequest;

  const LeaveRequestCard({
    super.key,
    required this.leaveRequest,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
        leading: SizedBox(
          width: 60,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.blue, size: 15),
                  SizedBox(width: 5),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg"),
                  ),
                ],
              )
            ],
          ),
        ),
        title: Text("Test"),
        subtitle: Text("Reason"),
        trailing: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("2024-02-20T07:00:00+07:00"),
            Text("2024-03-31T07:00:00+07:00"),
          ],
        ),
      ),
    );
  }
}

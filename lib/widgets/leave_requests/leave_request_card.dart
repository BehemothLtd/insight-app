import 'package:flutter/material.dart';
import 'package:insight_app/models/leave_request.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/utils/constants.dart';
import 'package:insight_app/utils/constants/leave_request.dart';
import 'package:insight_app/utils/time.dart';
import "package:insight_app/utils/helpers.dart";

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest leaveRequest;

  const LeaveRequestCard({
    super.key,
    required this.leaveRequest,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = leaveRequest.user?.avatarUrl ?? defaultNoImage();

    bool isNetworkUrl = checkNetworkUrl(imageUrl);
    return Card(
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
          leading: SizedBox(
            width: 60,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    if (leaveRequest.requestState != RequestState.pending)
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.transparent,
                      )
                    else
                      const Icon(Icons.circle, color: Colors.blue, size: 15),
                    const SizedBox(width: 5),
                    CircleAvatar(
                      backgroundImage: (isNetworkUrl
                          ? NetworkImage(imageUrl)
                          : AssetImage(imageUrl)) as ImageProvider<Object>,
                    ),
                  ],
                )
              ],
            ),
          ),
          title: Text(leaveRequest.user?.fullName ?? ""),
          subtitle: Text(
            leaveRequest.reason ?? "",
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (leaveRequest.requestState == RequestState.approved)
                  const Icon(
                    Icons.check_rounded,
                    color: LightColors.kGreen,
                  )
                else if (leaveRequest.requestState == RequestState.rejected)
                  const Icon(
                    Icons.cancel,
                    color: LightColors.kRed,
                  )
                else
                  const SizedBox(width: 15, height: 15,),
                const SizedBox(width: 7),
                Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(formatTime(leaveRequest.from, 'dd-MM-yyyy HH:mm')),
                    Text(formatTime(leaveRequest.to, 'dd-MM-yyyy HH:mm')),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

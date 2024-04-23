import 'dart:async';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:insight_app/controllers/leave_request_controller.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/utils/custom_snackbar.dart';
import 'package:insight_app/widgets/leave_requests/leave_request_card.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// The app which hosts the home page which contains the calendar on it.
class LeaveRequestsScreen extends StatelessWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Requests'),
      ),
      body: const Column(
        children: [
          Expanded(
            flex: 4,
            child: Calendar(),
          ),
          Expanded(
            flex: 6,
            child: RequestList(),
          ),
        ],
      ),
    );
  }
}

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  RequestListState createState() => RequestListState();
}

class RequestListState extends State<RequestList> {
  final leaveRequestController = Get.put(LeaveRequestController());
  final ScrollController _scrollController = ScrollController();

  bool _showScrollToTopButton = false;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    bool isBottom = _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;

    if (_scrollController.position.pixels > 0) {
      if (!_showScrollToTopButton) {
        setState(() => _showScrollToTopButton = true);
      }
      _resetScrollTimer();
    } else {
      if (_showScrollToTopButton) {
        setState(() => _showScrollToTopButton = false);
      }
    }

    if (isBottom) {
      _onScrollBottom();
    }
  }

  void _resetScrollTimer() {
    // print("_resetScrollTimer");

    _scrollTimer?.cancel(); // Cancel any existing timer
    _scrollTimer = Timer(const Duration(seconds: 2), () {
      setState(() => _showScrollToTopButton = false);
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onScrollBottom() async {
    await leaveRequestController.increasePage();

    try {
      await leaveRequestController.fetchLeaveRquests(false);
      showCustomSnackbar(
        message: 'More Requests Loaded',
        title: 'Notice',
        backgroundColor: Colors.blue,
        iconData: Icons.info,
        duration: 1,
      );
    } catch (e) {
      showCustomSnackbar(
        message: e.toString(),
        title: 'Info',
        backgroundColor: LightColors.kLightYellow2,
        iconData: Icons.warning,
        duration: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (leaveRequestController.leaveRquests.value?.isEmpty ?? true) {
        leaveRequestController.fetchLeaveRquests(true);
      }
    });

    return RefreshIndicator(
      child: Stack(
        children: [
          Container(
            color: LightColors.kLightYellow,
            child: Obx(() {
              var leaveRequests = leaveRequestController.leaveRquests.value;

              if (leaveRequests == null || leaveRequests.isEmpty) {
                return const Center(
                  child: Text("No LeaveRequest"),
                );
              } else {
                return ListView.builder(
                    controller: _scrollController,
                    itemCount: leaveRequests.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              label: 'Approved',
                              onPressed: (BuildContext context) {},
                            ),
                            SlidableAction(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              label: 'Reject',
                              onPressed: (BuildContext context) {},
                            ),
                          ],
                        ),
                        child: LeaveRequestCard(
                            leaveRequest: leaveRequests[index]),
                      );
                    });
              }
            }),
          ),
          if (_showScrollToTopButton) ...[
            Positioned(
              right: 20.0,
              bottom: 20.0,
              child: FloatingActionButton(
                backgroundColor: LightColors.kDarkYellow,
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
          ],
        ],
      ),
      onRefresh: () async {
        await leaveRequestController.resetPagy();
        await leaveRequestController.resetParams();

        await leaveRequestController.fetchLeaveRquests(true);
        showCustomSnackbar(
          message: 'Leave Requests Refreshed',
          title: 'Notice',
          backgroundColor: Colors.blue,
          iconData: Icons.info,
          duration: 1,
        );
      },
    );
  }
}

/// The hove page which hosts the calendarr
class Calendar extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const Calendar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.month,
      dataSource: MeetingDataSource(_getDataSource()),
      // by default the month appointment display mode set as Indicator, we can
      // change the display mode as appointment using the appointment display
      // mode property
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}

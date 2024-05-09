import 'dart:async';
import 'dart:ui';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:insight_app/controllers/leave_request_controller.dart';
import 'package:insight_app/models/leave_request.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/utils/constants/leave_request.dart';
import 'package:insight_app/utils/custom_snackbar.dart';
import 'package:insight_app/utils/helpers.dart';
import 'package:insight_app/widgets/leave_requests/leave_request_card.dart';
import 'package:insight_app/widgets/leave_requests/leave_requests_filter.dart';
import 'package:insight_app/widgets/uis/datepicker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// The app which hosts the home page which contains the calendar on it.
class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  LeaveRequestsScreenState createState() => LeaveRequestsScreenState();
}

class LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
  final leaveRequestController = Get.put(LeaveRequestController());
  final GlobalKey<DatepickerState> datePickerKey = GlobalKey<DatepickerState>();

  bool _isSearchPanelVisible = false;

  void _handleDateChange(PickerDateRange range) {
    leaveRequestController.resetPagy();

    leaveRequestController.leaveRequestsQuery.value?.fromGtEq =
        startOfDay(range.startDate ?? DateTime.now()).toString();
    leaveRequestController.leaveRequestsQuery.value?.toLtEq =
        endOfDay(range.endDate ?? DateTime.now()).toString();

    leaveRequestController.fetchLeaveRquests(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Leave Requests'),
          actions: [
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: child.key == const ValueKey('icon1')
                      ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                      : Tween<double>(begin: 0.75, end: 1).animate(anim),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: _isSearchPanelVisible
                    ? const Icon(Icons.search_off, key: ValueKey('icon1'))
                    : const Icon(
                        Icons.search,
                        key: ValueKey('icon2'),
                      ),
              ),
              onPressed: () {
                setState(() {
                  _isSearchPanelVisible = !_isSearchPanelVisible;
                });
              },
            )
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Datepicker(
                    onDateChange: _handleDateChange,
                    key: datePickerKey,
                  ),
                ),
                const Expanded(
                  flex: 6,
                  child: RequestList(),
                ),
              ],
            ),
            _buildSearchPanel(),
          ],
        ));
  }

  void _handleSearch() {
    setState(() {
      _isSearchPanelVisible = false;
    });

    // Trigger the search logic
    leaveRequestController.resetPagy();
    leaveRequestController.fetchLeaveRquests(true);
  }

  void _handleClear() {
    datePickerKey.currentState?.refreshRange();
  }

  Widget _buildSearchPanel() {
    return Visibility(
      visible: _isSearchPanelVisible,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Align(
          alignment: Alignment.center,
          child: LeaveRequestsFilter(
            onSearch: _handleSearch,
            clear: _handleClear,
          ),
        ),
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
    _scrollTimer?.cancel();
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
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Container(
              color: Colors.transparent,
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
                        var leaveRequest = leaveRequests[index];

                        final bool isSlidable =
                            leaveRequest.requestState == RequestState.pending ||
                                leaveRequest.requestState == "";

                        return Slidable(
                          endActionPane: isSlidable
                              ? ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    Container(
                                      width: 90,
                                      margin: const EdgeInsets.only(
                                          top: 6.0,
                                          bottom: 6.0,
                                          left: 6.0,
                                          right: 2.0),
                                      child: SlidableAction(
                                        backgroundColor: LightColors.kBlue,
                                        foregroundColor: Colors.white,
                                        spacing: 0,
                                        // label: 'Approved',
                                        icon: Icons.check,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                        onPressed:
                                            (BuildContext context) async {
                                          if (leaveRequest.id == null) return;

                                          String? newRequestState =
                                              await leaveRequestController
                                                  .approveLeaveRequest(
                                            LeaveRequestChangeStatusInput(
                                              id: leaveRequest.id!,
                                              requestState:
                                                  RequestState.approved,
                                            ),
                                          );
                                          if (newRequestState != null) {
                                            setState(() {
                                              leaveRequest.requestState =
                                                  newRequestState;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 90,
                                      margin: const EdgeInsets.only(
                                          top: 6.0, bottom: 6.0, right: 6.0),
                                      child: SlidableAction(
                                        backgroundColor: LightColors.kRed,
                                        foregroundColor: Colors.white,
                                        // label: 'Rejected',
                                        icon: Icons.cancel,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                        onPressed:
                                            (BuildContext context) async {
                                          if (leaveRequest.id == null) return;

                                          String? newRequestState =
                                              await leaveRequestController
                                                  .approveLeaveRequest(
                                            LeaveRequestChangeStatusInput(
                                              id: leaveRequest.id!,
                                              requestState:
                                                  RequestState.rejected,
                                            ),
                                          );
                                          if (newRequestState != null) {
                                            setState(() {
                                              leaveRequest.requestState =
                                                  newRequestState;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                          child: LeaveRequestCard(leaveRequest: leaveRequest),
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

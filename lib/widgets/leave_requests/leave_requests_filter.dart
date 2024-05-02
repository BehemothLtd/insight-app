import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/controllers/leave_request_controller.dart';

class LeaveRequestsFilter extends StatefulWidget {
  const LeaveRequestsFilter({
    super.key,
    required this.onSearch,
  });

  final VoidCallback onSearch;

  @override
  State<LeaveRequestsFilter> createState() => _LeaveRequestsFilterState();
}

class _LeaveRequestsFilterState extends State<LeaveRequestsFilter> {
  late TextEditingController requestStateController;
  late TextEditingController requestTypeController;

  final leaveRequestController = Get.put(LeaveRequestController());

  GlobalKey<FormFieldState> requestTypeDbKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> requestStateDbKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();

    requestTypeController = TextEditingController(
        text: leaveRequestController.leaveRequestsQuery.value?.requestTypeEq);
    requestStateController = TextEditingController(
        text: leaveRequestController.leaveRequestsQuery.value?.requestStateEq);
  }

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<FormFieldState> _key;

    final leaveRequestController = Get.find<LeaveRequestController>();

    final List<Map<String, String?>> requestTypes = [
      {'label': 'All', 'value': null},
      {'label': 'Day off', 'value': 'day_off'},
      {'label': 'WFH', 'value': 'wfh'},
      {'label': 'Insurance', 'value': 'insurance'},
      {'label': 'Personal day off', 'value': 'personal_days_off'},
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16), // Rounded corners for the AlertDialog
      ),
      title: const Row(
        children: [
          Icon(Icons.search, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            "Search",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        24.0,
        24.0,
        24.0,
        0,
      ), // Consistent padding
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 20.0,
      ), // Consistent padding
      content: SingleChildScrollView(
        // Ensures the dialog is scrollable on small devices
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                key: requestTypeDbKey,
                value: requestTypeController.text.isNotEmpty
                    ? requestTypeController.text
                    : null,
                decoration: InputDecoration(
                  labelText: 'Request Type',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  requestTypeController.text = value ?? '';

                  leaveRequestController.leaveRequestsQuery.update((val) {
                    val?.requestTypeEq = value ?? '';
                  });
                },
                items: requestTypes
                    .map<DropdownMenuItem<String>>((Map<String, String?> type) {
                  return DropdownMenuItem<String>(
                    value: type['value'],
                    child: Text(type['label']!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: requestStateDbKey,
                value: requestStateController.text.isNotEmpty
                    ? requestStateController.text
                    : null,
                decoration: InputDecoration(
                  labelText: 'State',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  requestStateController.text = value ?? '';

                  leaveRequestController.leaveRequestsQuery.update((val) {
                    val?.requestStateEq = value ?? '';
                  });
                },
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'approved', child: Text('Approved')),
                  DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            requestTypeDbKey.currentState?.reset();
            requestStateDbKey.currentState?.reset();

            leaveRequestController.resetParams();

            setState(() {});
          },
          child: const Text(
            'Clear',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onSearch();
          },
          child: Text(
            'Search',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

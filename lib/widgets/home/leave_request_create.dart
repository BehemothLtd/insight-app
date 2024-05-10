import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/controllers/leave_request_controller.dart';
import 'package:insight_app/models/leave_request.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/widgets/form/form_validator.dart';

class LeaveRequestCreate extends StatefulWidget {
  const LeaveRequestCreate({super.key});

  @override
  LeaveRequestCreateState createState() => LeaveRequestCreateState();
}

class LeaveRequestCreateState extends State<LeaveRequestCreate> {
  late DateTime from;
  late DateTime to;
  double? timeOff;
  String? requestType;
  String? reason;

  final TextEditingController _timeOffController = TextEditingController();

  final List<Map<String, String>> requestTypes = [
    {'label': 'Day off', 'value': 'day_off'},
    {'label': 'WFH', 'value': 'wfh'},
    {'label': 'Insurance', 'value': 'insurance'},
    {'label': 'Personal day off', 'value': 'personal_days_off'},
  ];

  final List<String> descriptions = [
    'Công việc đột xuất',
    'Công việc cá nhân / gia đình',
    'Khám/chữa bệnh',
    'Hiếu hỉ / ma chay',
    'Xe hỏng/ báo thức hỏng',
  ];

  final LeaveRequestController leaveRequestController =
      Get.put(LeaveRequestController());

  Future<void> _pickDate(BuildContext context,
      {required bool pickingFrom}) async {
    final initialDate = pickingFrom ? from : to;
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      if (!context.mounted) return;

      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );

      if (selectedTime != null) {
        setState(() {
          var selected = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );

          if (pickingFrom) {
            from = selected;
          } else {
            to = selected;
          }
        });
      }
    }

    _calculateTimeOff();
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    from = DateTime(now.year, now.month, now.day, 9, 00);
    to = DateTime(now.year, now.month, now.day, 18, 30);

    _calculateTimeOff();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _timeOffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomSheetHeight = MediaQuery.of(context).size.height * 0.75;

    return GestureDetector(
      onTap: () {
        // To hide keyboard when needed but keep the sheet open
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: bottomSheetHeight,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Request Leave',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 15),
              Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: FormValidator(
                      errorKey: 'from',
                      child: InkWell(
                        onTap: () => _pickDate(context, pickingFrom: true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'From*',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${from.toLocal()}'.split(':00.000')[0]),
                              Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    // This will ensure the width is constrained
                    child: FormValidator(
                      errorKey: 'to',
                      child: InkWell(
                        onTap: () => _pickDate(context, pickingFrom: false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'To*',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${to.toLocal()}'.split(':00.000')[0]),
                              Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              FormValidator(
                errorKey: "timeOff",
                child: TextFormField(
                  controller: _timeOffController,
                  decoration: const InputDecoration(
                    labelText: 'Time Off* (hours)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 14.0,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(height: 15),
              FormValidator(
                errorKey: "requestType",
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Request Type*',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 14.0,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  value: requestType,
                  items: requestTypes.map<DropdownMenuItem<String>>(
                      (Map<String, String> type) {
                    return DropdownMenuItem<String>(
                      value: type['value'],
                      child: Text(type['label']!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        requestType = newValue;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              FormValidator(
                errorKey: "reason",
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 14.0,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  value: reason,
                  items: descriptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      reason = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30), // Space at the bottom
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: Colors.green,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Request Leave',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        content: const Text(
                          'Are you sure you want to request leave?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();

                              _submitLeaveRequest();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightColors.kDarkYellow,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Submit Request',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateTimeOff() {
    if (from.day == to.day) {
      double hours = to.difference(from).inMinutes / 60.0;

      DateTime breakStart = DateTime(from.year, from.month, from.day, 12, 0);
      DateTime breakEnd = DateTime(from.year, from.month, from.day, 13, 30);

      if (from.isBefore(breakEnd) && to.isAfter(breakStart)) {
        DateTime overlapStart = from.isBefore(breakStart) ? breakStart : from;
        DateTime overlapEnd = to.isAfter(breakEnd) ? breakEnd : to;
        double breakHours =
            overlapEnd.difference(overlapStart).inMinutes / 60.0;
        hours -= breakHours;
      }

      timeOff = hours;
      _timeOffController.text = timeOff.toString();
    } else {
      int totalDays = to.difference(from).inDays + 1;

      timeOff = totalDays * 8;
      _timeOffController.text = timeOff.toString();
    }
  }

  void _submitLeaveRequest() async {
    timeOff = double.tryParse(_timeOffController.text);

    var leaveRequest = LeaveRequest(
      from: from,
      to: to,
      timeOff: timeOff ?? 0.0,
      requestType: requestType ?? "",
      reason: reason,
    );

    await leaveRequestController.createNewRequest(leaveRequest);
  }
}

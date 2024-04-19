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
  DateTime? from;
  DateTime? to;
  double? timeOff;
  String? requestType;
  String? description;

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
    final initialDate = pickingFrom ? from : to ?? DateTime.now();
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
              Row(
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
                              Text(from != null
                                  ? '${from!.toLocal()}'.split(':00.000')[0]
                                  : ''),
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
                              Text(to != null
                                  ? '${to!.toLocal()}'.split(':00.000')[0]
                                  : ''),
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
                errorKey: "description",
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 14.0,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  value: description,
                  items: descriptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      description = newValue;
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

  void _submitLeaveRequest() async {
    timeOff = double.tryParse(_timeOffController.text);

    var leaveRequest = LeaveRequest(
      from: from,
      to: to,
      timeOff: timeOff ?? 0.0,
      requestType: requestType,
      description: description,
    );

    await leaveRequestController.createNewRequest(leaveRequest);
  }
}

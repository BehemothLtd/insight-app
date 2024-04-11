import 'package:flutter/material.dart';
import 'package:insight_app/theme/colors/light_colors.dart';

class LeaveRequestCreate extends StatefulWidget {
  const LeaveRequestCreate({super.key});

  @override
  _LeaveRequestCreateState createState() => _LeaveRequestCreateState();
}

class _LeaveRequestCreateState extends State<LeaveRequestCreate> {
  DateTime? from;
  DateTime? to;
  double? timeOff;
  String? requestType;
  String? description;

  final TextEditingController _timeOffController = TextEditingController();

  final List<String> requestTypes = [
    'Day off',
    'WFH',
    'Insurance',
    'Personal day off',
  ];

  final List<String> descriptions = [
    'Công việc đột xuất',
    'Công việc cá nhân / gia đình',
    'Khám/chữa bệnh',
    'Hiếu hỉ / ma chay',
    'Xe hỏng/ báo thức hỏng',
  ];

  Future<void> _pickDate(BuildContext context,
      {required bool pickingFrom}) async {
    final initialDate = pickingFrom ? from : to ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (pickingFrom) {
          from = picked;
        } else {
          to = picked;
        }
      });
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

    return Container(
      height: bottomSheetHeight,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Request Leave',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                // "From" Date Picker
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, pickingFrom: true),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'From*',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(from != null
                              ? '${from!.toLocal()}'.split(' ')[0]
                              : ''),
                          Icon(Icons.calendar_today,
                              color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Spacing between the pickers
                // "To" Date Picker
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, pickingFrom: false),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'To*',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(to != null
                              ? '${to!.toLocal()}'.split(' ')[0]
                              : ''),
                          Icon(Icons.calendar_today,
                              color: Theme.of(context).primaryColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _timeOffController,
              decoration: const InputDecoration(
                labelText: 'Time Off* (hours)',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              // You can still use onChanged if you want to do something every time the value changes.
              // But for submission purposes, the controller will hold the final value.
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Request Type*',
                border: OutlineInputBorder(),
              ),
              value: requestType,
              items: requestTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  requestType = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              value: description,
              items: descriptions.map<DropdownMenuItem<String>>((String value) {
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
            const SizedBox(height: 30), // Space at the bottom
            ElevatedButton(
              onPressed: () {
                timeOff = double.tryParse(_timeOffController.text);

                // Implement your submission logic
                print(from);
                print(to);
                print(timeOff);
                print(requestType);
                print(description);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: LightColors.kDarkYellow,
                minimumSize:
                    const Size(double.infinity, 50), // full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // rounded button
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
    );
  }
}

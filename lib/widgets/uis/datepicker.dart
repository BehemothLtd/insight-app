import 'package:flutter/material.dart';
import 'package:insight_app/utils/helpers.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Datepicker extends StatefulWidget {
  const Datepicker({
    super.key,
    required this.onDateChange,
  });

  final Function(PickerDateRange) onDateChange;

  @override
  // ignore: library_private_types_in_public_api
  DatepickerState createState() => DatepickerState();
}

class DatepickerState extends State<Datepicker> {
  late PickerDateRange _selectedRange;

  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    _selectedRange =
        PickerDateRange(startOfDay(DateTime.now()), endOfDay(DateTime.now()));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      DateTime startDate = args.value.startDate;
      DateTime endDate = args.value.endDate ?? args.value.startDate;

      PickerDateRange range = PickerDateRange(startDate, endDate);

      widget.onDateChange(range);

      setState(() {
        _selectedRange = args.value;
      });
    }
  }

  void refreshRange() {
    PickerDateRange range =
        PickerDateRange(startOfDay(DateTime.now()), endOfDay(DateTime.now()));
    _controller.selectedRange = range;

    setState(() {
      _selectedRange = range;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SfDateRangePicker(
            controller: _controller,
            initialSelectedRange: _selectedRange,
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            backgroundColor: Colors.white,
            toggleDaySelection: true,
            headerHeight: 55,
            headerStyle: const DateRangePickerHeaderStyle(
              textAlign: TextAlign.center,
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            monthViewSettings: const DateRangePickerMonthViewSettings(
              viewHeaderStyle: DateRangePickerViewHeaderStyle(
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            monthCellStyle: DateRangePickerMonthCellStyle(
              textStyle: const TextStyle(
                color: Colors.black,
              ),
              todayTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              todayCellDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              cellDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            selectionTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            selectionColor: Colors.orange,
            rangeSelectionColor: Colors.orange.withOpacity(0.5),
            startRangeSelectionColor: Colors.orange,
            endRangeSelectionColor: Colors.orange,
            showNavigationArrow: true,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) =>
                _onSelectionChanged(args),
          ),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}

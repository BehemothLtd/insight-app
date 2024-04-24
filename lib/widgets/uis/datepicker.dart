import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Datepicker extends StatefulWidget {
  const Datepicker({
    super.key,
    required this.onDateChange,
  });

  final Function(PickerDateRange) onDateChange;

  @override
  // ignore: library_private_types_in_public_api
  _DatepickerState createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SfDateRangePicker(
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
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value is PickerDateRange) {
              DateTime startDate = args.value.startDate;
              DateTime endDate = args.value.endDate ?? args.value.startDate;

              PickerDateRange range = PickerDateRange(startDate, endDate);

              widget.onDateChange(range);
            }
          },
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    ));
  }
}

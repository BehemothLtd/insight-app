import 'package:intl/intl.dart';

String formatTime(DateTime? time, String formatter) {
  if (time == null) return '';

  DateTime localTime = time.toLocal();

  String formattedTime = DateFormat(formatter).format(localTime);

  return formattedTime;
}

DateTime? formatDateFromDDMMYYYY(String dateString) {
  DateFormat format = DateFormat("dd-MM-yyyy");
  try {
    DateTime dateTime = format.parse(dateString);
    return dateTime;
  } catch (e) {
    return null;
  }
}

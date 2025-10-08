import 'package:intl/intl.dart';

String formateDate(DateTime date) {
  final formattedDate = DateFormat(
    'dd - MMM - yyyy',
  ).format(date);
  return formattedDate;
}

String formatTime(DateTime date) {
  final formattedTime = DateFormat('h:mm a').format(date);
  return formattedTime;
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promas/providers/user_provider.dart';

String formateDate(DateTime date) {
  final formattedDate = DateFormat(
    'dd - MMM - yyyy',
  ).format(date);
  return formattedDate;
}

String formatShortDate(DateTime date) {
  String day = date.day.toString();
  String suffix;

  if (day.endsWith('1') && day != '11') {
    suffix = 'st';
  } else if (day.endsWith('2') && day != '12') {
    suffix = 'nd';
  } else if (day.endsWith('3') && day != '13') {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }

  String weekday = DateFormat('E').format(date);
  return '${date.day}$suffix - $weekday.';
}

String formatShortDateTwo(DateTime date) {
  String day = date.day.toString();
  String suffix;

  if (day.endsWith('1') && day != '11') {
    suffix = 'st';
  } else if (day.endsWith('2') && day != '12') {
    suffix = 'nd';
  } else if (day.endsWith('3') && day != '13') {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }
  final month = DateFormat('MMM').format(date);

  String weekday = DateFormat('E').format(date);
  return '$weekday ${date.day}$suffix $month';
}

String formatFullDate(DateTime date) {
  String day = date.day.toString();
  String suffix;

  if (day.endsWith('1') && day != '11') {
    suffix = 'st';
  } else if (day.endsWith('2') && day != '12') {
    suffix = 'nd';
  } else if (day.endsWith('3') && day != '13') {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }

  String weekday = DateFormat('EEEE').format(date);
  String month = DateFormat('MMMM').format(date);
  String year = DateFormat('y').format(date);

  return '$weekday - ${date.day}$suffix - $month - $year';
}

String formatTime(DateTime date) {
  final formattedTime = DateFormat('h:mm a').format(date);
  return formattedTime;
}

String returnGreetingText() {
  final now = DateTime.now();
  final hour = now.hour; // 0–23
  final user = UserProvider().currentUser;
  final name = user != null && user.name.isNotEmpty
      ? (user.name.split(' ').length > 1
            ? user.name.split(' ').first
            : user.name)
      : 'User';

  if (hour < 12) {
    return 'Good Morning $name';
  } else if (hour < 17) {
    return 'Good Afternoon $name';
  } else {
    return 'Good Evening $name';
  }
}

IconData returnGreetingIcon() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour < 17) {
    return Icons.sunny;
  } else {
    return Icons.nightlight;
  }
}

String cutLongText(int count, String text) {
  if (text.length > count) {
    return '${text.substring(0, count)}...';
  } else {
    return text;
  }
}

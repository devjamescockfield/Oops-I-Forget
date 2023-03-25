import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(appointments![index].startDate);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(appointments![index].endDate);
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  Color getColor(int index) {
    return Colors.green;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].allDay;
  }
}
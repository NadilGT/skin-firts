import 'package:flutter/material.dart';

import '../../../../data/models/day_data_model/day_data.dart';
import 'day_schedule_view.dart';
import 'weekly_calender_selector.dart';

class CalendarScheduleWidget extends StatefulWidget {
  final double? width;
  final double? height;
  
  const CalendarScheduleWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _CalendarScheduleWidgetState createState() => _CalendarScheduleWidgetState();
}

class _CalendarScheduleWidgetState extends State<CalendarScheduleWidget> {
  int selectedDay = 11;

  final List<DayData> days = [
    DayData(day: 9, weekday: 'MON', isSelected: false),
    DayData(day: 10, weekday: 'TUE', isSelected: false),
    DayData(day: 11, weekday: 'WED', isSelected: true),
    DayData(day: 12, weekday: 'THU', isSelected: false),
    DayData(day: 13, weekday: 'FRI', isSelected: true),
    DayData(day: 14, weekday: 'SAT', isSelected: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 400,
      height: widget.height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8FF),
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WeeklyCalendarSelector(
            days: days,
            selectedDay: selectedDay,
            onDaySelected: (day) {
              setState(() {
                selectedDay = day;
              });
            },
          ),
          const SizedBox(height: 20),
          const DayScheduleView(),
        ],
      ),
    );
  }
}
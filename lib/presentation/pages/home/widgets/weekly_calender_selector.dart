// Weekly Calendar Selector Widget
import 'package:flutter/material.dart';

import '../../../../data/models/day_data_model/day_data.dart';
import 'day_button.dart';

class WeeklyCalendarSelector extends StatelessWidget {
  final List<DayData> days;
  final int selectedDay;
  final Function(int) onDaySelected;

  // ignore: use_super_parameters
  const WeeklyCalendarSelector({
    Key? key,
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.map((dayData) {
        return DayButton(
          dayData: dayData,
          isCurrentlySelected: dayData.day == selectedDay,
          onTap: () => onDaySelected(dayData.day),
        );
      }).toList(),
    );
  }
}
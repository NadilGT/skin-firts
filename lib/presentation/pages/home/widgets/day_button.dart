import 'package:flutter/material.dart';

import '../../../../data/models/day_data_model/day_data.dart';

class DayButton extends StatelessWidget {
  final DayData dayData;
  final bool isCurrentlySelected;
  final VoidCallback onTap;

  // ignore: use_super_parameters
  const DayButton({
    Key? key,
    required this.dayData,
    required this.isCurrentlySelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool shouldHighlight = dayData.isSelected || isCurrentlySelected;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          color: shouldHighlight
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayData.day.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: shouldHighlight
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              dayData.weekday,
              style: TextStyle(
                fontSize: 12,
                color: shouldHighlight
                    ? Colors.white70
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
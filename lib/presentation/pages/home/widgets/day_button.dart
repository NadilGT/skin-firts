import 'package:flutter/material.dart';
import '../../../../data/models/day_data_model/day_data.dart';

class DayButton extends StatelessWidget {
  final DayData dayData;
  final bool isCurrentlySelected;
  final VoidCallback onTap;

  const DayButton({
    Key? key,
    required this.dayData,
    required this.isCurrentlySelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: 44,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isCurrentlySelected
              ? const Color(0xFF4A90D9)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isCurrentlySelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A90D9).withOpacity(0.45),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayData.weekday,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isCurrentlySelected
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white.withOpacity(0.45),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${dayData.day}",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isCurrentlySelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
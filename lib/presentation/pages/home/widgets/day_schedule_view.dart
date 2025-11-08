// Day Schedule View Widget
import 'package:flutter/material.dart';

import '../../../../data/models/appointment_model/appoinment_data.dart';
import 'appointment_slot.dart';
import 'time_slot.dart';

class DayScheduleView extends StatelessWidget {
  const DayScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '11 Wednesday - Today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(height: 16),
          TimeSlot(time: '9 AM'),
          AppointmentSlot(
            time: '10 AM',
            appointment: AppointmentData(
              doctorName: 'Dr. Olivia Turner, M.D.',
              description: 'Treatment and prevention of\nskin and photodermatitis.',
            ),
          ),
          TimeSlot(time: '11 AM'),
          TimeSlot(time: '12 AM'),
        ],
      ),
    );
  }
}
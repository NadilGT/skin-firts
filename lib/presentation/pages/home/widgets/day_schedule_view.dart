import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/appointment/appointment_model.dart';

class DayScheduleView extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final DateTime selectedDate;

  const DayScheduleView({
    Key? key,
    required this.appointments,
    required this.selectedDate,
  }) : super(key: key);

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Theme.of(context).colorScheme.secondary;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Theme.of(context).colorScheme.error;
      case 'completed':
        return Theme.of(context).primaryColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(height: 16),
            Text(
              'No appointments scheduled',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMMM d, yyyy').format(selectedDate),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      );
    }

    // Sort appointments by time
    final sortedAppointments = List<AppointmentModel>.from(appointments)
      ..sort((a, b) => a.timeSlot.compareTo(b.timeSlot));

    return ListView.builder(
      itemCount: sortedAppointments.length,
      itemBuilder: (context, index) {
        final appointment = sortedAppointments[index];
        final statusColor = _getStatusColor(context, appointment.status);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: statusColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 20,
                          color: statusColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          appointment.timeSlot,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        appointment.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.person,
                        size: 18,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.patientName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.medical_services,
                        size: 18,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dr. ${appointment.doctorName}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                if (appointment.doctorSpecialty != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const SizedBox(width: 26),
                      Text(
                        appointment.doctorSpecialty!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ],
                if (appointment.notes != null &&
                    appointment.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note,
                          size: 18,
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          appointment.notes!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
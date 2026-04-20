import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/appointment/appointment_model.dart';
import '../../../../core/localization/app_localizations.dart';

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

  // Returns a soft background tint for each status
  Color _getStatusBg(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Theme.of(context).colorScheme.secondary.withOpacity(0.08);
      case 'pending':
        return Colors.orange.withOpacity(0.07);
      case 'cancelled':
        return Theme.of(context).colorScheme.error.withOpacity(0.07);
      case 'completed':
        return Theme.of(context).primaryColor.withOpacity(0.07);
      default:
        return Colors.grey.withOpacity(0.07);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: (Theme.of(context).brightness == Brightness.light ? const Color(0xFF1C2B4A) : Colors.white).withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 32,
                color: (Theme.of(context).brightness == Brightness.light ? const Color(0xFF1C2B4A) : Colors.white).withOpacity(0.35),
              ),
            ),
            const SizedBox(height: 16),
              Text(
                loc.noAppointments,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleMedium?.color ??
                      const Color(0xFF1C2B4A),
                  letterSpacing: -0.2,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMMM d, yyyy').format(selectedDate),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    final sortedAppointments = List<AppointmentModel>.from(appointments);

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: sortedAppointments.length,
      itemBuilder: (context, index) {
        final appointment = sortedAppointments[index];
        final statusColor = _getStatusColor(context, appointment.status);
        final statusBg = _getStatusBg(context, appointment.status);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: (Theme.of(context).brightness == Brightness.light ? const Color(0xFF1C2B4A) : Colors.black).withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Left accent bar ──────────────────────────
                  Container(
                    width: 4,
                    color: statusColor,
                  ),

                  // ── Card body ────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time + Status badge row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.access_time_rounded,
                                      size: 14,
                                      color: statusColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '#${appointment.appointmentNumber}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).textTheme.titleSmall?.color ?? const Color(0xFF1C2B4A),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: statusColor.withOpacity(0.25),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  loc.translateStatus(appointment.status).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          Container(
                            height: 1,
                            color: (Theme.of(context).brightness == Brightness.light ? const Color(0xFF1C2B4A) : Colors.white).withOpacity(0.06),
                          ),
                          const SizedBox(height: 12),

                          // Patient name
                          Row(
                            children: [
                              _InfoIcon(
                                icon: Icons.person_rounded,
                                color: const Color(0xFF4A90D9),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  appointment.patientName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).textTheme.titleSmall?.color ?? const Color(0xFF1C2B4A),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Doctor name
                          Row(
                            children: [
                              _InfoIcon(
                                icon: Icons.medical_services_rounded,
                                color: const Color(0xFF4A90D9),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  loc.doctorPrefix(appointment.doctorName),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).textTheme.bodyMedium?.color ?? const Color(0xFF1C2B4A),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Specialty
                          if (appointment.doctorSpecialty != null) ...[
                            const SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: Text(
                                appointment.doctorSpecialty!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],

                          // Notes
                          if (appointment.notes != null &&
                              appointment.notes!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.light ? const Color(0xFFF5F7FA) : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.notes_rounded,
                                    size: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      appointment.notes!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Small helper for info row icons ─────────────────────────────────────────
class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _InfoIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/appointment/appointment_model.dart';
import '../../../../data/models/day_data_model/day_data.dart';
import '../../calender/bloc1/appointments_cubit.dart';
import '../../calender/bloc1/appointments_state.dart';
import 'day_schedule_view.dart';
import 'weekly_calender_selector.dart';

class CalendarScheduleWidget extends StatefulWidget {
  final double? width;
  final double? height;

  const CalendarScheduleWidget({super.key, this.width, this.height});

  @override
  _CalendarScheduleWidgetState createState() => _CalendarScheduleWidgetState();
}

class _CalendarScheduleWidgetState extends State<CalendarScheduleWidget> {
  late DateTime selectedDate;
  late List<DayData> days;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    days = _generateWeekDays(selectedDate);
    context.read<AppointmentCubits>().getAllAppointments();
  }

  List<DayData> _generateWeekDays(DateTime centerDate) {
    final List<DayData> weekDays = [];
    final startDate = centerDate.subtract(const Duration(days: 2));
    for (int i = 0; i < 6; i++) {
      final date = startDate.add(Duration(days: i));
      weekDays.add(DayData(
        day: date.day,
        weekday: DateFormat('EEE').format(date).toUpperCase(),
        isSelected: _isSameDay(date, centerDate),
        fullDate: date,
      ));
    }
    return weekDays;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _onDaySelected(int day) {
    setState(() {
      final selectedDayData = days.firstWhere((d) => d.day == day);
      selectedDate = selectedDayData.fullDate ?? selectedDate;
      for (var dayData in days) {
        dayData.isSelected = dayData.day == day;
      }
    });
  }

  List<DayData> _updateDaysWithAppointments(
    List<DayData> days,
    List<AppointmentModel> appointments,
  ) {
    return days.map((dayData) {
      // ignore: unused_local_variable
      final hasAppointment = appointments.any((appointment) =>
          _isSameDay(
              appointment.appointmentDate, dayData.fullDate ?? DateTime.now()));
      return DayData(
        day: dayData.day,
        weekday: dayData.weekday,
        isSelected: dayData.isSelected,
        fullDate: dayData.fullDate,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 400,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C2B4A).withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BlocBuilder<AppointmentCubits, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentLoading) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF4A90D9),
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            if (state is AppointmentError) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: Colors.red.shade300, size: 36),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        context
                            .read<AppointmentCubits>()
                            .refreshAppointments();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF4A90D9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFF4A90D9)),
                        ),
                      ),
                      child: const Text("Retry",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              );
            }

            final appointments = state is AppointmentLoaded
                ? state.appointments
                : <AppointmentModel>[];

            final selectedDateAppointments = appointments
                .where((a) => _isSameDay(a.appointmentDate, selectedDate))
                .toList();

            final updatedDays =
                _updateDaysWithAppointments(days, appointments);

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Week header strip ─────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1C2B4A),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(selectedDate),
                        style: const TextStyle(
                          color: Color(0xFF7EB8F7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 14),
                      WeeklyCalendarSelector(
                        days: updatedDays,
                        selectedDay: selectedDate.day,
                        onDaySelected: _onDaySelected,
                      ),
                    ],
                  ),
                ),

                // ── Day schedule ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 300,
                    child: DayScheduleView(
                      appointments: selectedDateAppointments,
                      selectedDate: selectedDate,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
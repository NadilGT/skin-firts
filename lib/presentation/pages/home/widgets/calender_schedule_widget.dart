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
  
  const CalendarScheduleWidget({
    super.key,
    this.width,
    this.height,
  });

  @override
  // ignore: library_private_types_in_public_api
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
      
      // Update selection status
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
          _isSameDay(appointment.appointmentDate, dayData.fullDate ?? DateTime.now()));
      
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<AppointmentCubits, AppointmentsState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AppointmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AppointmentCubits>().refreshAppointments();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final appointments = state is AppointmentLoaded 
              ? state.appointments 
              : <AppointmentModel>[];

          final selectedDateAppointments = appointments.where((appointment) =>
              _isSameDay(appointment.appointmentDate, selectedDate)).toList();

          final updatedDays = _updateDaysWithAppointments(days, appointments);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WeeklyCalendarSelector(
                days: updatedDays,
                selectedDay: selectedDate.day,
                onDaySelected: _onDaySelected,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: DayScheduleView(
                  appointments: selectedDateAppointments,
                  selectedDate: selectedDate,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
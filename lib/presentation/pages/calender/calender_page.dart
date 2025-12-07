import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/models/appointment/appointment_model.dart';
import '../../../domain/usecases/appointment_usecase/appointment_usecase.dart';
import '../../../domain/usecases/appointment_usecase/get_all_appointments_usecase.dart';
import '../../../service_locator.dart';
import '../book_appointment/book_appointment_page.dart';
import 'bloc/appoinment_cubit.dart';
import 'bloc/appointments_cubit.dart';
import 'bloc/appointments_state.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentCubits(
        getAllAppointmentsUsecase: sl<GetAllAppointmentsUsecase>(),
      )..getAllAppointments(),
      child: const CalendarPageContent(),
    );
  }
}

class CalendarPageContent extends StatefulWidget {
  const CalendarPageContent({super.key});

  @override
  State<CalendarPageContent> createState() => _CalendarPageContentState();
}

class _CalendarPageContentState extends State<CalendarPageContent> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  final Map<DateTime, List<AppointmentModel>> _appointments = {};
  List<AppointmentModel> _selectedDayAppointments = [];
  int _upcomingAppointments = 0;
  int _completedAppointments = 0;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  void _loadAppointmentsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    setState(() {
      _selectedDayAppointments = _appointments[normalizedDay] ?? [];
    });
  }

  void _organizeAppointments(List<AppointmentModel> appointmentsList) {
    _appointments.clear();
    int upcoming = 0;
    int completed = 0;

    for (var appointment in appointmentsList) {
      final normalizedDate = DateTime(
        appointment.appointmentDate.year,
        appointment.appointmentDate.month,
        appointment.appointmentDate.day,
      );

      if (_appointments.containsKey(normalizedDate)) {
        _appointments[normalizedDate]!.add(appointment);
      } else {
        _appointments[normalizedDate] = [appointment];
      }

      if (appointment.status.toLowerCase() == 'confirmed' ||
          appointment.status.toLowerCase() == 'pending') {
        upcoming++;
      } else if (appointment.status.toLowerCase() == 'completed') {
        completed++;
      }
    }

    setState(() {
      _upcomingAppointments = upcoming;
      _completedAppointments = completed;
    });

    _loadAppointmentsForDay(_selectedDay);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Theme.of(context).colorScheme.primary;
      case 'pending':
        return Theme.of(context).colorScheme.secondary;
      case 'completed':
        return Theme.of(context).colorScheme.primary;
      case 'cancelled':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _formatTime(String timeSlot) {
    try {
      // If timeSlot is already formatted, return it
      if (timeSlot.contains('AM') || timeSlot.contains('PM')) {
        return timeSlot;
      }

      // Try to parse and format if it's in 24-hour format
      final time = DateFormat('HH:mm').parse(timeSlot);
      return DateFormat('hh:mm a').format(time);
    } catch (e) {
      return timeSlot;
    }
  }

  void _navigateToBookAppointment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => AppointmentCubit(
            appointmentUsecase: sl<AppointmentUsecase>(),
          ),
          child: const BookAppointmentPage(),
        ),
      ),
    );

    if (result == true) {
      // Refresh the appointments list after booking
      context.read<AppointmentCubits>().refreshAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text(
          'My Appointments',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              context.read<AppointmentCubits>().refreshAppointments();
            },
          ),
        ],
      ),
      body: BlocConsumer<AppointmentCubits, AppointmentsState>(
        listener: (context, state) {
          if (state is AppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }

          if (state is AppointmentLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _organizeAppointments(state.appointments);
            });
          }
        },
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          if (state is AppointmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error.withOpacity(0.7)),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load appointments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AppointmentCubits>().getAllAppointments();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildSummaryCard(
                        'Upcoming',
                        _upcomingAppointments,
                        Theme.of(context).colorScheme.primary,
                        Icons.calendar_today,
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryCard(
                        'Completed',
                        _completedAppointments,
                        Theme.of(context).colorScheme.primary,
                        Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),

                // Calendar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: Theme.of(context).textTheme.titleMedium!,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 1,
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _loadAppointmentsForDay(selectedDay);
                    },
                    eventLoader: (day) {
                      final normalizedDay = DateTime(
                        day.year,
                        day.month,
                        day.day,
                      );
                      return _appointments[normalizedDay] ?? [];
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Appointments Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                      _selectedDayAppointments.isEmpty
                          ? 'No appointments'
                          : '${_selectedDayAppointments.length} Appointment${_selectedDayAppointments.length > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.titleLarge),
                ),

                // Appointments List
                _selectedDayAppointments.isEmpty
                    ? Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No appointments on this day',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _selectedDayAppointments.length,
                        itemBuilder: (context, index) {
                          return _buildAppointmentCard(
                            _selectedDayAppointments[index],
                          );
                        },
                      ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToBookAppointment,
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.background),
        label: Text(
          'Book Appointment',
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 2),
            Text(title, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Doctor Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            // Appointment Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctorName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  if (appointment.doctorSpecialty != null)
                    Text(
                      appointment.doctorSpecialty!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(appointment.timeSlot),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        _getStatusIcon(appointment.status),
                        size: 16,
                        color: _getStatusColor(appointment.status),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appointment.status.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(appointment.status),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action Buttons
            IconButton(
              onPressed: () => _showAppointmentDetails(appointment),
              icon: const Icon(Icons.more_vert),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(AppointmentModel appointment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(Icons.person, 'Doctor', appointment.doctorName),
            if (appointment.doctorSpecialty != null)
              _buildDetailRow(
                Icons.medical_services,
                'Specialty',
                appointment.doctorSpecialty!,
              ),
            _buildDetailRow(
              Icons.person_outline,
              'Patient',
              appointment.patientName,
            ),
            _buildDetailRow(
              Icons.calendar_today,
              'Date',
              DateFormat('MMM dd, yyyy').format(appointment.appointmentDate),
            ),
            _buildDetailRow(
              Icons.access_time,
              'Time',
              _formatTime(appointment.timeSlot),
            ),
            _buildDetailRow(
              Icons.info_outline,
              'Status',
              appointment.status.toUpperCase(),
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty)
              _buildDetailRow(Icons.note, 'Notes', appointment.notes!),
            const SizedBox(height: 24),
            Row(
              children: [
                if (appointment.status.toLowerCase() != 'completed' &&
                    appointment.status.toLowerCase() != 'cancelled')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showCancelDialog(appointment);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(color: Theme.of(context).colorScheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                if (appointment.status.toLowerCase() != 'completed' &&
                    appointment.status.toLowerCase() != 'cancelled')
                  const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Navigate to reschedule page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reschedule feature coming soon'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reschedule'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Appointment'),
        content: Text(
          'Are you sure you want to cancel your appointment with ${appointment.doctorName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement appointment cancellation logic here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Appointment cancellation feature not available yet.'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
              context.read<AppointmentCubits>().refreshAppointments();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

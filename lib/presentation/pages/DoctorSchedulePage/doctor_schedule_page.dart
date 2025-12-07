// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/models/appointment/appointment_model.dart';
import '../calender/bloc/appoinment_cubit.dart';
import '../calender/bloc/appointment_state.dart';

class DoctorSchedulePage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImage;
  final Map<DateTime, List<String>> doctorSchedule;

  const DoctorSchedulePage({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImage,
    required this.doctorSchedule,
  });

  @override
  State<DoctorSchedulePage> createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<String> _selectedTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadTimeSlotsForDay(_selectedDay);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadTimeSlotsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    setState(() {
      _selectedTimeSlots = widget.doctorSchedule[normalizedDay] ?? [];
    });
  }

  // ignore: unused_element
  List<DateTime> _getScheduledDays() {
    return widget.doctorSchedule.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: theme.appBarTheme.iconTheme?.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Schedule',
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Appointment booked successfully!'),
                backgroundColor: colorScheme.primary,
                duration: const Duration(seconds: 3),
              ),
            );
            Navigator.pop(context, true);
          } else if (state is AppointmentFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to book appointment: ${state.error}'),
                backgroundColor: colorScheme.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      backgroundImage: NetworkImage(widget.doctorImage),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doctorName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.doctorSpecialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Calendar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 90)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: theme.primaryColor,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: theme.primaryColor,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    defaultTextStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    weekendTextStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _loadTimeSlotsForDay(selectedDay);
                  },
                  eventLoader: (day) {
                    final normalizedDay = DateTime(day.year, day.month, day.day);
                    return widget.doctorSchedule[normalizedDay] ?? [];
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Available Time Slots
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Time Slots',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _selectedTimeSlots.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'No available slots for this day',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: _selectedTimeSlots
                                .map((timeSlot) => _buildTimeSlotChip(timeSlot))
                                .toList(),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotChip(String timeSlot) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        _showBookingConfirmation(timeSlot);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.primaryColor, width: 1.5),
        ),
        child: Text(
          timeSlot,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }

  void _showBookingConfirmation(String timeSlot) {
    showDialog(
      context: context,
      builder: (dialogContext) => _BookingDialog(
        doctorId: widget.doctorId,
        doctorName: widget.doctorName,
        doctorSpecialty: widget.doctorSpecialty,
        selectedDay: _selectedDay,
        timeSlot: timeSlot,
        appointmentCubit: context.read<AppointmentCubit>(),
      ),
    );
  }
}

// Separate StatefulWidget for the dialog to manage its own controllers
class _BookingDialog extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final DateTime selectedDay;
  final String timeSlot;
  final AppointmentCubit appointmentCubit;

  const _BookingDialog({
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.selectedDay,
    required this.timeSlot,
    required this.appointmentCubit,
  });

  @override
  State<_BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<_BookingDialog> {
  late final TextEditingController patientIdController;
  late final TextEditingController patientNameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController notesController;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    patientIdController = TextEditingController();
    patientNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    notesController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    patientIdController.dispose();
    patientNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return BlocProvider.value(
      value: widget.appointmentCubit,
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentCreated) {
            Navigator.pop(context);
          } else if (state is AppointmentFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AppointmentLoading;

          return AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Confirm Appointment',
              style: TextStyle(color: theme.textTheme.titleLarge?.color),
            ),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appointment Details
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doctor: ${widget.doctorName}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${widget.selectedDay.toString().split(' ')[0]}',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Time: ${widget.timeSlot}',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: colorScheme.outlineVariant),
                    const SizedBox(height: 16),

                    // Patient Information Section
                    Text(
                      'Patient Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Patient ID Field
                    TextFormField(
                      controller: patientIdController,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        labelText: 'Patient ID *',
                        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        hintText: 'Enter patient ID',
                        hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                        prefixIcon: Icon(
                          Icons.badge,
                          color: theme.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Patient ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Patient Name Field
                    TextFormField(
                      controller: patientNameController,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        labelText: 'Full Name *',
                        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        hintText: 'Enter patient name',
                        hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: theme.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Patient name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Email Field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        labelText: 'Email *',
                        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                        prefixIcon: Icon(
                          Icons.email,
                          color: theme.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Phone Number Field
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        labelText: 'Phone Number (Optional)',
                        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: theme.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Notes Field
                    TextFormField(
                      controller: notesController,
                      maxLines: 3,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      decoration: InputDecoration(
                        labelText: 'Notes (Optional)',
                        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        hintText: 'Any additional information',
                        hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                        prefixIcon: Icon(
                          Icons.note_outlined,
                          color: theme.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          final appointment = AppointmentModel(
                            patientId: patientIdController.text.trim(),
                            patientName: patientNameController.text.trim(),
                            patientEmail: emailController.text.trim(),
                            patientPhone: phoneController.text.trim().isEmpty
                                ? null
                                : phoneController.text.trim(),
                            doctorId: widget.doctorId,
                            doctorName: widget.doctorName,
                            doctorSpecialty: widget.doctorSpecialty.isEmpty
                                ? null
                                : widget.doctorSpecialty,
                            appointmentDate: widget.selectedDay,
                            timeSlot: widget.timeSlot,
                            notes: notesController.text.trim().isEmpty
                                ? null
                                : notesController.text.trim(),
                            status: 'pending',
                          );

                          widget.appointmentCubit.createAppointment(appointment);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Confirm',
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
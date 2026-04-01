// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/appointment/appointment_model.dart';
import '../../../data/models/doctor_schedule_model/doctor_schedule_model.dart';
import '../calender/bloc/appoinment_cubit.dart';
import '../calender/bloc/appointment_state.dart';
import '../appointment/next_appointment_number_cubit/next_appointment_number_cubit.dart';
import '../appointment/next_appointment_number_cubit/next_appointment_number_state.dart';

class DoctorSchedulePage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImage;
  final DoctorScheduleResponseModel doctorSchedule;

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
  late final Set<DateTime> _availableDatesSet;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    // Parse and normalize available dates
    final dates = widget.doctorSchedule.availableDates
        .map((e) => DateTime.tryParse(e.date))
        .whereType<DateTime>()
        .map((e) => DateTime(e.year, e.month, e.day))
        .toList();
    dates.sort();
    _availableDatesSet = dates.toSet();

    _focusedDay = DateTime.now();
    final normalizedToday = DateTime(
      _focusedDay.year,
      _focusedDay.month,
      _focusedDay.day,
    );

    // Initialize selected day to the first available date if today is not available
    if (_availableDatesSet.contains(normalizedToday)) {
      _selectedDay = normalizedToday;
    } else if (_availableDatesSet.isNotEmpty) {
      _selectedDay = _availableDatesSet.first;
      _focusedDay = _selectedDay;
    } else {
      _selectedDay = normalizedToday;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_availableDatesSet.contains(
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day),
      )) {
        context.read<NextAppointmentNumberCubit>().getNextAppointmentNumber(
          widget.doctorId,
          _selectedDay.toString().split(' ')[0],
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  List<DateTime> _getScheduledDays() {
    return _availableDatesSet.toList();
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
          icon: Icon(
            Icons.arrow_back,
            color: theme.appBarTheme.iconTheme?.color,
          ),
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
                    defaultTextStyle: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    weekendTextStyle: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    final normalizedDay = DateTime(
                      selectedDay.year,
                      selectedDay.month,
                      selectedDay.day,
                    );
                    if (!_availableDatesSet.contains(normalizedDay)) return;

                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    context
                        .read<NextAppointmentNumberCubit>()
                        .getNextAppointmentNumber(
                          widget.doctorId,
                          selectedDay.toString().split(' ')[0],
                        );
                  },
                  enabledDayPredicate: (day) {
                    final normalizedDay = DateTime(
                      day.year,
                      day.month,
                      day.day,
                    );
                    return _availableDatesSet.contains(normalizedDay);
                  },
                  eventLoader: (day) {
                    final normalizedDay = DateTime(
                      day.year,
                      day.month,
                      day.day,
                    );
                    return _availableDatesSet.contains(normalizedDay)
                        ? [true]
                        : [];
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Available Time Slots -> Next Appointment Number
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Appointment Number',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<
                      NextAppointmentNumberCubit,
                      NextAppointmentNumberState
                    >(
                      builder: (context, state) {
                        if (state is NextAppointmentNumberLoading) {
                          return Container(
                            padding: const EdgeInsets.all(40),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: theme.primaryColor,
                            ),
                          );
                        } else if (state is NextAppointmentNumberLoaded) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.primaryColor.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Your Number Will Be',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    state
                                        .nextAppointmentNumber
                                        .nextAppointmentNumber
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 64,
                                      fontWeight: FontWeight.w900,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColor,
                                      foregroundColor: colorScheme.onPrimary,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showBookingConfirmation(
                                        state
                                            .nextAppointmentNumber
                                            .nextAppointmentNumber,
                                      );
                                    },
                                    child: const Text(
                                      'Book Appointment',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (state is NextAppointmentNumberError) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Error: ${state.error}',
                                    style: TextStyle(color: colorScheme.error),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Select a date to view the next available number',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        );
                      },
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

  void _showBookingConfirmation(int appointmentNumber) {
    showDialog(
      context: context,
      builder: (dialogContext) => _BookingDialog(
        doctorId: widget.doctorId,
        doctorName: widget.doctorName,
        doctorSpecialty: widget.doctorSpecialty,
        selectedDay: _selectedDay,
        appointmentNumber: appointmentNumber,
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
  final int appointmentNumber;
  final AppointmentCubit appointmentCubit;

  const _BookingDialog({
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.selectedDay,
    required this.appointmentNumber,
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

    // Pre-fill user information from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      patientIdController.text = user.uid;
      patientNameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
    }
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

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 24,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.brightness == Brightness.dark
                    ? const Color(0xFF1E2A3A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1C2B4A).withOpacity(0.18),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header strip ──────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1C2B4A), Color(0xFF2E4A7A)],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color(0xFF7EB8F7),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Confirm Appointment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Appointment summary chips
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            child: Column(
                              children: [
                                _DialogInfoRow(
                                  icon: Icons.person_rounded,
                                  label: 'Doctor',
                                  value: widget.doctorName,
                                  light: true,
                                ),
                                const SizedBox(height: 8),
                                _DialogInfoRow(
                                  icon: Icons.calendar_today_rounded,
                                  label: 'Date',
                                  value: widget.selectedDay.toString().split(
                                    ' ',
                                  )[0],
                                  light: true,
                                ),
                                const SizedBox(height: 8),
                                _DialogInfoRow(
                                  icon: Icons.tag_rounded,
                                  label: 'Appt. #',
                                  value: widget.appointmentNumber.toString(),
                                  light: true,
                                  accent: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Form body ─────────────────────────────────────────────
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Section label
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Patient Information',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1C2B4A),
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Patient ID
                              _DialogField(
                                controller: patientIdController,
                                readOnly: true,
                                label: 'Patient ID',
                                hint: 'Enter patient ID',
                                icon: Icons.badge_rounded,
                                primaryColor: theme.primaryColor,
                                colorScheme: colorScheme,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Patient ID is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Full Name
                              _DialogField(
                                controller: patientNameController,
                                label: 'Full Name *',
                                hint: 'Enter patient name',
                                icon: Icons.person_outline_rounded,
                                primaryColor: theme.primaryColor,
                                colorScheme: colorScheme,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Patient name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Email
                              _DialogField(
                                controller: emailController,
                                label: 'Email *',
                                hint: 'Enter your email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                primaryColor: theme.primaryColor,
                                colorScheme: colorScheme,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Phone
                              _DialogField(
                                controller: phoneController,
                                label: 'Phone Number (Optional)',
                                hint: 'Enter your phone number',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                primaryColor: theme.primaryColor,
                                colorScheme: colorScheme,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    if (!RegExp(
                                      r'^\+?[\d\s-]{10,}$',
                                    ).hasMatch(value)) {
                                      return 'Please enter a valid phone number';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Notes
                              _DialogField(
                                controller: notesController,
                                label: 'Notes (Optional)',
                                hint: 'Any additional information',
                                icon: Icons.notes_rounded,
                                maxLines: 3,
                                primaryColor: theme.primaryColor,
                                colorScheme: colorScheme,
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Action buttons ────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.withOpacity(0.10)),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Cancel
                          Expanded(
                            child: GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF1C2B4A,
                                  ).withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF1C2B4A,
                                    ).withOpacity(0.12),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Confirm
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        final appointment = AppointmentModel(
                                          appointmentId: '',
                                          appointmentNumber:
                                              widget.appointmentNumber,
                                          patientId: patientIdController.text
                                              .trim(),
                                          patientName: patientNameController
                                              .text
                                              .trim(),
                                          patientEmail: emailController.text
                                              .trim(),
                                          patientPhone:
                                              phoneController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : phoneController.text.trim(),
                                          doctorId: widget.doctorId,
                                          doctorName: widget.doctorName,
                                          doctorSpecialty:
                                              widget.doctorSpecialty.isEmpty
                                              ? null
                                              : widget.doctorSpecialty,
                                          appointmentDate: widget.selectedDay,
                                          notes:
                                              notesController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : notesController.text.trim(),
                                          status: 'pending',
                                        );
                                        widget.appointmentCubit
                                            .createAppointment(appointment);
                                      }
                                    },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: isLoading
                                      ? null
                                      : const LinearGradient(
                                          colors: [
                                            Color(0xFF1C2B4A),
                                            Color(0xFF2E4A7A),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                  color: isLoading
                                      ? const Color(0xFF1C2B4A).withOpacity(0.5)
                                      : null,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: isLoading
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF1C2B4A,
                                            ).withOpacity(0.28),
                                            blurRadius: 14,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                ),
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Confirm',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Dialog info row (used in the header summary) ─────────────────────────────
class _DialogInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool light;
  final bool accent;

  const _DialogInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.light = false,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 13,
          color: accent
              ? const Color(0xFF7EB8F7)
              : Colors.white.withOpacity(0.55),
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.55),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: accent ? const Color(0xFF7EB8F7) : Colors.white,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Reusable dialog text field ────────────────────────────────────────────────
class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool readOnly;
  final int maxLines;
  final TextInputType? keyboardType;
  final Color primaryColor;
  final ColorScheme colorScheme;
  final String? Function(String?)? validator;

  const _DialogField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.primaryColor,
    required this.colorScheme,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF1C2B4A),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: primaryColor, size: 18),
        filled: true,
        fillColor: readOnly
            ? const Color(0xFF1C2B4A).withOpacity(0.04)
            : const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: colorScheme.error.withOpacity(0.6), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: maxLines > 1 ? 14 : 0,
        ),
      ),
      validator: validator,
    );
  }
}

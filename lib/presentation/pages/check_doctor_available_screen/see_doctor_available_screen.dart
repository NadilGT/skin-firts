import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';
import 'package:skin_firts/domain/entity/doctor_availability_entity/doctor_availability_entity.dart';

import 'get_doctor_availability_cubit/get_doctor_availability_cubit.dart';
import 'get_doctor_availability_cubit/get_doctor_availability_state.dart';

class SeeDoctorAvailableScreen extends StatefulWidget {
  final DoctorInfoModel doctor;
  const SeeDoctorAvailableScreen({super.key, required this.doctor});

  @override
  State<SeeDoctorAvailableScreen> createState() =>
      _SeeDoctorAvailableScreenState();
}

class _SeeDoctorAvailableScreenState extends State<SeeDoctorAvailableScreen> {
  DateTime selectedDate = DateTime.now();

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _formatDisplayDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return "${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  void _fetchAvailability(BuildContext context) {
    context.read<GetDoctorAvailabilityCubit>().getDoctorAvailability(
          DoctorAvailabilityParams(
            doctorId: widget.doctor.doctor_id,
            date: _formatDate(selectedDate),
          ),
        );
  }

  Future<void> _pickDate(BuildContext context) async {
    final primaryColor = Theme.of(context).primaryColor;
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF1C2B4A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
      _fetchAvailability(context);
    }
  }

  // Build a row of next 7 days for quick selection
  List<DateTime> get _quickDates =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1C2B4A);
    final subtitleColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500;

    return BlocProvider(
      create: (context) => GetDoctorAvailabilityCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text(
              'Check Availability',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Doctor Card ───────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? cardColor : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(isDarkMode ? 0.3 : 0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.15),
                              width: 2.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: primaryColor.withOpacity(0.08),
                            backgroundImage:
                                widget.doctor.profile_pic.isNotEmpty
                                    ? NetworkImage(widget.doctor.profile_pic)
                                    : null,
                            child: widget.doctor.profile_pic.isEmpty
                                ? Icon(Icons.person_rounded,
                                    color: primaryColor, size: 28)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.doctor.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.doctor.special,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Colors.amber, size: 14),
                                  const SizedBox(width: 3),
                                  Text(
                                    (widget.doctor.starts ?? 0.0).toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: subtitleColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(Icons.work_outline_rounded,
                                      color: subtitleColor, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${widget.doctor.experience ?? 0} yrs exp",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Date Picker Section ───────────────────────────────
                  Text(
                    "Select a Date",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick date strip (next 7 days)
                  SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _quickDates.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final date = _quickDates[index];
                        final isSelected =
                            _formatDate(date) == _formatDate(selectedDate);
                        const dayLabels = [
                          'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
                        ];
                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedDate = date);
                            _fetchAvailability(context);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            width: 52,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : (isDarkMode
                                      ? cardColor
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? primaryColor.withOpacity(0.3)
                                      : Colors.black
                                          .withOpacity(isDarkMode ? 0.3 : 0.05),
                                  blurRadius: isSelected ? 12 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayLabels[date.weekday - 1],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.85)
                                        : subtitleColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${date.day}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Full date picker button
                  GestureDetector(
                    onTap: () => _pickDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        color: isDarkMode ? cardColor : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(isDarkMode ? 0.2 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 16, color: primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _formatDisplayDate(selectedDate),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              color: primaryColor, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Availability Result ───────────────────────────────
                  BlocBuilder<GetDoctorAvailabilityCubit,
                      GetDoctorAvailabilityState>(
                    builder: (context, state) {
                      if (state is GetDoctorAvailabilityInitial) {
                        return _buildPromptCard(
                          context,
                          primaryColor: primaryColor,
                          textColor: textColor,
                          subtitleColor: subtitleColor,
                          isDarkMode: isDarkMode,
                          cardColor: cardColor,
                        );
                      } else if (state is GetDoctorAvailabilityLoading) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      } else if (state is GetDoctorAvailabilityLoaded) {
                        return _buildResultCard(
                          context,
                          data: state.doctorAvailabilityModel,
                          primaryColor: primaryColor,
                          textColor: textColor,
                          subtitleColor: subtitleColor,
                          isDarkMode: isDarkMode,
                          cardColor: cardColor,
                        );
                      } else if (state is GetDoctorAvailabilityError) {
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: Colors.red, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  state.error,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Check Button ──────────────────────────────────────────────
          bottomNavigationBar: BlocBuilder<GetDoctorAvailabilityCubit,
              GetDoctorAvailabilityState>(
            builder: (context, state) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: GestureDetector(
                    onTap: state is GetDoctorAvailabilityLoading
                        ? null
                        : () => _fetchAvailability(context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 54,
                      decoration: BoxDecoration(
                        color: state is GetDoctorAvailabilityLoading
                            ? primaryColor.withOpacity(0.5)
                            : primaryColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: state is GetDoctorAvailabilityLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Check Availability",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildPromptCard(
    BuildContext context, {
    required Color primaryColor,
    required Color textColor,
    required Color subtitleColor,
    required bool isDarkMode,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? cardColor : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available_rounded,
              color: primaryColor.withOpacity(0.6),
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Select a date & tap\n\"Check Availability\"",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: subtitleColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context, {
    required dynamic data,
    required Color primaryColor,
    required Color textColor,
    required Color subtitleColor,
    required bool isDarkMode,
    required Color cardColor,
  }) {
    final isAvailable = data.isAvailable as bool;
    final statusColor = isAvailable ? const Color(0xFF22C55E) : Colors.redAccent;
    final statusBg = isAvailable
        ? const Color(0xFF22C55E).withOpacity(0.08)
        : Colors.redAccent.withOpacity(0.08);
    final statusBorder = isAvailable
        ? const Color(0xFF22C55E).withOpacity(0.2)
        : Colors.redAccent.withOpacity(0.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Status Banner ─────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAvailable
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAvailable ? "Doctor is Available" : "Not available this doctor",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDisplayDate(selectedDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor.withOpacity(0.75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Detail Cards ──────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? cardColor : Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(isDarkMode ? 0.3 : 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (isAvailable) ...[
                _detailRow(
                  icon: Icons.access_time_rounded,
                  label: "Estimated Start Time",
                  value: data.estimatedStartTime ?? "—",
                  primaryColor: primaryColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                ),
                _divider(isDarkMode),
              ],
              if ((data.notes as String).isNotEmpty) ...[
                _divider(isDarkMode),
                _detailRow(
                  icon: Icons.sticky_note_2_outlined,
                  label: "Doctor's Note",
                  value: data.notes,
                  primaryColor: primaryColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                  valueMaxLines: 3,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider(bool isDarkMode) => Divider(
        height: 24,
        thickness: 1,
        color: isDarkMode
            ? Colors.white.withOpacity(0.06)
            : Colors.grey.withOpacity(0.1),
      );

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryColor,
    required Color textColor,
    required Color subtitleColor,
    int valueMaxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: primaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: valueMaxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
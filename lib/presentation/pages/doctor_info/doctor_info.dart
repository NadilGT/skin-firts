// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/core/constants/api_constants.dart';
import 'package:skin_firts/domain/entity/doctor_info_entity/doctor_info_entity.dart';
import 'package:skin_firts/domain/usecases/toggle_favorite_usecase/toggle_favorite_usecase.dart';
import 'package:skin_firts/presentation/pages/doctor_info/bloc/doctor_info_cubit.dart';
import 'package:skin_firts/presentation/pages/doctor_info/bloc/doctor_info_state.dart';
import 'package:skin_firts/service_locator.dart';

import '../../../common/widgets/appBar/app_bar.dart';
import '../../../core/storage/data_state.dart';
import '../../../data/models/doctor_info_model/doctor_info_model.dart';
import '../../../domain/repositories/doctor_schedule/DoctorScheduleRepository.dart';
import '../DoctorSchedulePage/doctor_schedule_page.dart' show DoctorSchedulePage;
import '../calender/bloc/appoinment_cubit.dart';
import '../appointment/next_appointment_number_cubit/next_appointment_number_cubit.dart';

class DoctorInfo extends StatefulWidget {
  final DoctorInfoModel doctor;
  const DoctorInfo({super.key, required this.doctor});

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  DoctorInfoEntity? doctorInfo;
  bool isFavorite = false;

  @override
  void initState() {
    isFavorite = widget.doctor.favorite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return BlocProvider(
      create: (context) =>
          DoctorInfoCubit()..getDoctorInfo(widget.doctor.name),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: BasicAppbar(
          title: Text(
            "Doctor Profile",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Theme.of(context).textTheme.titleLarge?.color ?? (Theme.of(context).brightness == Brightness.light ? const Color(0xFF1C2B4A) : Colors.white),
              letterSpacing: -0.3,
            ),
          ),
          action: Row(
            children: [
              _appBarIcon(Icons.search_rounded),
              const SizedBox(width: 8),
              _appBarIcon(Icons.menu_rounded),
            ],
          ),
        ),
        body: BlocBuilder<DoctorInfoCubit, DoctorInfoState>(
          builder: (context, state) {
            if (state is DoctorInfoLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  strokeWidth: 2,
                ),
              );
            } else if (state is DoctorInfoLoaded) {
              doctorInfo = state.doctorInfoEntity;
            }

            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // ── Hero card ──────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF1C2B4A),
                            Theme.of(context).brightness == Brightness.light ? primaryColor : const Color(0xFF2260FF).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(Theme.of(context).brightness == Brightness.light ? 0.35 : 0.1),
                            blurRadius: 32,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar + badge row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 38,
                                  backgroundImage:
                                      NetworkImage(widget.doctor.profile_pic),
                                  backgroundColor:
                                      Colors.white.withOpacity(0.15),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Experience + focus badge
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.verified_rounded,
                                              color: Colors.white, size: 15),
                                          const SizedBox(width: 6),
                                          Text(
                                            doctorInfo?.experience.toString() ??
                                                "...",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        'experience',
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Focus',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        doctorInfo?.focus ?? "—",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Name + specialty
                          Text(
                            doctorInfo?.name ?? widget.doctor.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            doctorInfo?.special ?? widget.doctor.special,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Divider
                          Container(
                            height: 1,
                            color: Colors.white.withOpacity(0.12),
                          ),

                          const SizedBox(height: 16),

                          // Stats row
                          Row(
                            children: [
                              _StatChip(
                                icon: Icons.star_rounded,
                                iconColor: Colors.amber,
                                label: doctorInfo?.starts.toString() ?? "0",
                              ),
                              const SizedBox(width: 14),
                              _StatChip(
                                icon: Icons.chat_bubble_outline_rounded,
                                iconColor: Colors.white70,
                                label: doctorInfo?.messages.toString() ?? "0",
                              ),
                              const SizedBox(width: 14),
                              _StatChip(
                                icon: Icons.access_time_rounded,
                                iconColor: Colors.white70,
                                label: doctorInfo?.date.toString() ?? "DD/MM",
                                small: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Action buttons row
                          Row(
                            children: [
                              // Schedule button
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      ),
                                    );
                                    try {
                                      final repository =
                                          DoctorScheduleRepository(
                                              baseUrl: ApiConstants.baseURL);
                                      final scheduleResponse =
                                          await repository.getDoctorSchedule(
                                              doctorInfo!.name);
                                      if (mounted) Navigator.pop(context);
                                      if (mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MultiBlocProvider(
                                              providers: [
                                                BlocProvider(
                                                    create: (context) =>
                                                        sl<AppointmentCubit>()),
                                                BlocProvider(
                                                    create: (context) =>
                                                        sl<NextAppointmentNumberCubit>()),
                                              ],
                                              child: DoctorSchedulePage(
                                                doctorId: widget.doctor.doctor_id,
                                                doctorName: doctorInfo!.name,
                                                doctorSpecialty: doctorInfo!.special,
                                                doctorImage: doctorInfo!.profile_pic,
                                                doctorSchedule: scheduleResponse.schedules,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) Navigator.pop(context);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Failed to load schedule: $e'),
                                          backgroundColor:
                                              Theme.of(context).colorScheme.error,
                                        ));
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_month_rounded,
                                            size: 16, color: primaryColor),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Schedule',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).brightness == Brightness.light ? primaryColor : Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              _buildActionButton(Icons.info_outline_rounded,
                                  () {}),
                              const SizedBox(width: 8),
                              _buildActionButton(
                                  Icons.share_outlined, () {}),
                              const SizedBox(width: 8),
                              _buildActionButton(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                () async {
                                  try {
                                    final updatedDoctor =
                                        await sl<ToggleFavoriteUsecase>().call(
                                      params: widget.doctor.name,
                                    );
                                    if (updatedDoctor
                                        is DataSuccess<DoctorInfoModel>) {
                                      setState(() {
                                        isFavorite =
                                            updatedDoctor.data!.favorite;
                                      });
                                    }
                                  } catch (e) {
                                    print("Error toggling favorite: $e");
                                  }
                                },
                                color: isFavorite
                                    ? Colors.red.shade300
                                    : Colors.white70,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Info sections ────────────────────────────────────
                    _buildInfoSection('Profile', doctorInfo?.profile ?? "—"),
                    const SizedBox(height: 12),
                    _buildInfoSection('Career Path', doctorInfo?.career ?? "—"),
                    const SizedBox(height: 12),
                    _buildInfoSection(
                        'Highlights', doctorInfo?.highlights ?? "—"),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _appBarIcon(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon,
          color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Colors.white, size: 18),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed,
      {Color? color}) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? Colors.white70, size: 18),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.black).withOpacity(Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleSmall?.color ?? (Theme.of(context).brightness == Brightness.light ? const Color(0xFF1C2B4A) : Colors.white.withOpacity(0.9)),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.grey.shade600,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat chip helper ─────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool small;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: small ? 11 : 13,
          ),
        ),
      ],
    );
  }
}
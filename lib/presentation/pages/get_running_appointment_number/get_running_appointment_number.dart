import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/models/doctor_info_model/doctor_info_model.dart';
import '../../../data/models/running_appointment_number_model/running_appointment_number_model.dart';
import 'cubit/get_running_appointment_number_cubit.dart';
import 'cubit/get_running_appointment_number_state.dart';

class GetRunningAppointmentNumber extends StatefulWidget {
  final DoctorInfoModel doctor;
  const GetRunningAppointmentNumber({super.key, required this.doctor});

  @override
  State<GetRunningAppointmentNumber> createState() =>
      _GetRunningAppointmentNumberState();
}

class _GetRunningAppointmentNumberState
    extends State<GetRunningAppointmentNumber>
    with TickerProviderStateMixin {

  String get _todayFormatted =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  late final AnimationController _pulseController;
  late final AnimationController _entryController;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Pulsing ring on the number card
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Page entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return BlocProvider(
      create: (context) => GetRunningAppointmentNumberCubit()
        ..getRunningAppointmentNumber(
          widget.doctor.doctor_id,
          _todayFormatted,
        ),
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Collapsing Hero Header ─────────────────────────────
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: scaffoldBg,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _CircleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      isDarkMode: isDarkMode,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: _HeroHeader(
                      doctor: widget.doctor,
                      primaryColor: primaryColor,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),

                // ── Body Content ───────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Date pill
                      _DateBadge(
                        primaryColor: primaryColor,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 28),

                      // Section label
                      _SectionLabel(
                        label: 'NOW SERVING',
                        primaryColor: primaryColor,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 14),

                      // Main result area
                      BlocConsumer<GetRunningAppointmentNumberCubit,
                          GetRunningAppointmentNumberState>(
                        listener: (context, state) {
                          if (state is GetRunningAppointmentNumberError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error.toString()),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is GetRunningAppointmentNumberLoading) {
                            return _LoadingCard(
                              primaryColor: primaryColor,
                              isDarkMode: isDarkMode,
                            );
                          }
                          if (state is GetRunningAppointmentNumberLoaded) {
                            return _NumberDisplay(
                              number: state.runningAppointmentNumber,
                              primaryColor: primaryColor,
                              isDarkMode: isDarkMode,
                              pulseAnim: _pulseAnim,
                            );
                          }
                          if (state is GetRunningAppointmentNumberError) {
                            return _ErrorDisplay(
                              message: state.error.toString(),
                              primaryColor: primaryColor,
                              isDarkMode: isDarkMode,
                              onRetry: () {
                                context
                                    .read<GetRunningAppointmentNumberCubit>()
                                    .getRunningAppointmentNumber(
                                      widget.doctor.doctor_id,
                                      _todayFormatted,
                                    );
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      ),

                      const SizedBox(height: 28),

                      // Info strip
                      _InfoStrip(
                        primaryColor: primaryColor,
                        isDarkMode: isDarkMode,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  final DoctorInfoModel doctor;
  final Color primaryColor;
  final bool isDarkMode;

  const _HeroHeader({
    required this.doctor,
    required this.primaryColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Decorative background arc
        CustomPaint(painter: _ArcPainter(color: primaryColor)),

        // Content
        Positioned(
          bottom: 28,
          left: 24,
          right: 24,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar with ring
              _AvatarRing(
                doctor: doctor,
                primaryColor: primaryColor,
              ),
              const SizedBox(width: 18),
              // Doctor info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        doctor.special,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.star_rounded,
                          value: (doctor.starts ?? 0.0).toStringAsFixed(1),
                          color: const Color(0xFFFFB800),
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          icon: Icons.work_outline_rounded,
                          value: '${doctor.experience ?? 0} yrs',
                          color: primaryColor,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarRing extends StatelessWidget {
  final DoctorInfoModel doctor;
  final Color primaryColor;

  const _AvatarRing({required this.doctor, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: CircleAvatar(
        radius: 41,
        backgroundColor: primaryColor.withOpacity(0.1),
        backgroundImage: doctor.profile_pic.isNotEmpty
            ? NetworkImage(doctor.profile_pic)
            : null,
        child: doctor.profile_pic.isEmpty
            ? Icon(Icons.person_rounded, color: primaryColor, size: 36)
            : null,
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final bool isDarkMode;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.color,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATE BADGE
// ─────────────────────────────────────────────────────────────────────────────
class _DateBadge extends StatelessWidget {
  final Color primaryColor;
  final bool isDarkMode;

  const _DateBadge({required this.primaryColor, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_month_rounded, color: primaryColor, size: 16),
          const SizedBox(width: 8),
          Text(
            DateFormat('EEEE, MMMM d · yyyy').format(now),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white70 : Colors.black54,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION LABEL
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color primaryColor;
  final bool isDarkMode;

  const _SectionLabel({
    required this.label,
    required this.primaryColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
            color: isDarkMode ? Colors.white54 : Colors.black45,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NUMBER DISPLAY
// ─────────────────────────────────────────────────────────────────────────────
class _NumberDisplay extends StatelessWidget {
  final RunningAppointmentNumberModel number;
  final Color primaryColor;
  final bool isDarkMode;
  final Animation<double> pulseAnim;

  const _NumberDisplay({
    required this.number,
    required this.primaryColor,
    required this.isDarkMode,
    required this.pulseAnim,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white;
    final borderColor = isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.grey.shade200;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // Top accent bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.0),
                  primaryColor,
                  primaryColor.withOpacity(0.0),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 36),
            child: Column(
              children: [
                // Live indicator dot
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: pulseAnim,
                      builder: (_, __) => Transform.scale(
                        scale: pulseAnim.value,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                        color: Colors.greenAccent.shade400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // The big number with pulsing rings
                AnimatedBuilder(
                  animation: pulseAnim,
                  builder: (_, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer ring
                        Transform.scale(
                          scale: 0.92 + (pulseAnim.value - 0.92) * 1.6,
                          child: Container(
                            width: 168,
                            height: 168,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor.withOpacity(0.08),
                                width: 16,
                              ),
                            ),
                          ),
                        ),
                        // Inner ring
                        Transform.scale(
                          scale: 0.94 + (pulseAnim.value - 0.92) * 0.8,
                          child: Container(
                            width: 136,
                            height: 136,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor.withOpacity(0.14),
                                width: 10,
                              ),
                            ),
                          ),
                        ),
                        // Center filled circle
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                primaryColor.withOpacity(0.22),
                                primaryColor.withOpacity(0.10),
                              ],
                            ),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: child,
                        ),
                      ],
                    );
                  },
                  child: Center(
                    child: Text(
                      number.running_appointment_number.toString(),
                      style: TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                        height: 1,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Token Number',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Currently being served',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADING CARD
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingCard extends StatelessWidget {
  final Color primaryColor;
  final bool isDarkMode;

  const _LoadingCard({required this.primaryColor, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3,
              strokeCap: StrokeCap.round,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Fetching live data...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white38 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR DISPLAY
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorDisplay extends StatelessWidget {
  final String message;
  final Color primaryColor;
  final bool isDarkMode;
  final VoidCallback onRetry;

  const _ErrorDisplay({
    required this.message,
    required this.primaryColor,
    required this.isDarkMode,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: Colors.redAccent,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Could not load data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO STRIP
// ─────────────────────────────────────────────────────────────────────────────
class _InfoStrip extends StatelessWidget {
  final Color primaryColor;
  final bool isDarkMode;

  const _InfoStrip({required this.primaryColor, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: primaryColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This number updates in real time. Pull down to refresh.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDarkMode
                    ? Colors.white60
                    : Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CIRCLE BUTTON
// ─────────────────────────────────────────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.07),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CUSTOM PAINTER — decorative arc in hero
// ─────────────────────────────────────────────────────────────────────────────
class _ArcPainter extends CustomPainter {
  final Color color;
  _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Large soft background arc
    paint.color = color.withOpacity(0.08);
    final path = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.1,
        size.width,
        size.height * 0.45,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path, paint);

    // Smaller accent arc
    paint.color = color.withOpacity(0.05);
    final path2 = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.35,
        size.width * 0.8,
        size.height * 0.6,
      )
      ..quadraticBezierTo(size.width, size.height * 0.65, size.width, size.height * 0.5)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path2, paint);

    // Decorative circles
    paint.color = color.withOpacity(0.06);
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.18),
      size.width * 0.22,
      paint,
    );
    paint.color = color.withOpacity(0.04);
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.12),
      size.width * 0.14,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) => oldDelegate.color != color;
}
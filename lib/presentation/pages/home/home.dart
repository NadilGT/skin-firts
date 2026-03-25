import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_firts/domain/usecases/appointment_usecase/get_all_appointments_usecase.dart';
import 'package:skin_firts/presentation/pages/appointment/appointment.dart';
import 'package:skin_firts/presentation/pages/home/bloc/doctors_cubit.dart';
import 'package:skin_firts/presentation/pages/home/bloc/doctors_state.dart';
import 'package:skin_firts/service_locator.dart';
import '../../../data/models/doctor_info_model/doctor_info_model.dart';
import '../calender/bloc1/appointments_cubit.dart';
import 'widgets/calender_schedule_widget.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();

  static Widget _iconButton(BuildContext context, String asset) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(8),
      width: 40,
      height: 40,
      child: SvgPicture.asset(
        asset,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}

class _HomeState extends State<Home> {
  List<DoctorInfoModel> doctors = [];
  String? userName;

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
    _getUserName();
  }

  void _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (!mounted) return;
      setState(() {
        userName = user.displayName;
      });
    }
  }

  Future<void> _initFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }
    String? token = await messaging.getToken();
    print('FCM Token: $token');
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DoctorsCubit()..getDoctors(),
        ),
        BlocProvider(
          create: (context) => AppointmentCubits(
            getAllAppointmentsUsecase: sl<GetAllAppointmentsUsecase>(),
          )..getAllAppointments(
              params: FirebaseAuth.instance.currentUser?.uid ?? ""),
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state is DoctorsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4A90D9),
                  strokeWidth: 2.5,
                ),
              );
            } else if (state is DoctorsLoaded) {
              doctors = state.doctors;
            }

            return CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 60, right: 24, left: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Avatar with a soft ring
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF4A90D9),
                                  width: 2,
                                ),
                              ),
                              child: const CircleAvatar(
                                radius: 22,
                                backgroundImage:
                                    AssetImage("assets/images/profile.jpg"),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Morning 👋",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6) ?? Colors.grey.shade500,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  userName ?? "User",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.titleLarge?.color ?? const Color(0xFF1C2B4A),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 28)),

                // ── "Your Schedule" label ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Schedule",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).textTheme.titleLarge?.color ?? const Color(0xFF1C2B4A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Upcoming appointments",
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6) ?? Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CalendarScheduleWidget(
                          width: MediaQuery.of(context).size.width - 48,
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 28)),

                // ── Book Appointment button ──────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).brightness == Brightness.light ? const Color(0xFF1C2B4A) : Theme.of(context).colorScheme.surface,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month_rounded,
                              size: 18, color: Color(0xFF7EB8F7)),
                          SizedBox(width: 10),
                          Text(
                            "Book Appointment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }
}
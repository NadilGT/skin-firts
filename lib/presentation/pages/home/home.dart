import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_firts/common/widgets/doc_profile_card/doctor_profile_card.dart';
import 'package:skin_firts/common/widgets/searchBar/custom_search_bar.dart';
import 'package:skin_firts/core/constants/color_manager.dart';
import 'package:skin_firts/domain/usecases/appointment_usecase/get_all_appointments_usecase.dart';
import 'package:skin_firts/presentation/pages/doctors_list_screen/doctors_list_screen.dart';
import 'package:skin_firts/presentation/pages/home/bloc/doctors_cubit.dart';
import 'package:skin_firts/presentation/pages/home/bloc/doctors_state.dart';
import 'package:skin_firts/presentation/pages/messages/messages_page.dart';
import 'package:skin_firts/presentation/pages/profile/profile_page.dart';
import 'package:skin_firts/service_locator.dart';

import '../../../data/models/doctor_info_model/doctor_info_model.dart';
import '../calender/bloc1/appointments_cubit.dart';
import 'widgets/calender_schedule_widget.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();

  static Widget _iconButton(String asset) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(8),
      width: 40,
      height: 40,
      child: SvgPicture.asset(asset),
    );
  }
}

class _HomeState extends State<Home> {
  List<DoctorInfoModel> doctors = [];

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
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
          )..getAllAppointments(),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state is DoctorsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoctorsLoaded) {
              doctors = state.doctors;
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      right: 30,
                      left: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/profile.jpg",
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Hi, WelcomeBack",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Nadil Dinsara",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessagesPage(),
                                  ),
                                );
                              },
                              child: Home._iconButton(
                                "assets/images/notification.svg",
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(),
                                  ),
                                );
                              },
                              child: Home._iconButton(
                                "assets/images/setting.svg",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 25)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorsListScreen(),
                              ),
                            );
                          },
                          child: _menu("assets/images/doc.svg", "Doctors"),
                        ),
                        // const SizedBox(width: 15),
                        // _menu("assets/images/fav.svg", "Favorite"),
                        const SizedBox(width: 10),
                        const Expanded(child: CustomSearchBar()),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CalendarScheduleWidget(
                      width: MediaQuery.of(context).size.width - 60,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final doctor = doctors[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: DoctorProfileCard(
                        doctorName: doctor.name,
                        specialty: doctor.special,
                        imageUrl: doctor.profilePic,
                        rating: doctor.starts.toDouble(),
                        reviewCount: doctor.messages,
                      ),
                    );
                  }, childCount: doctors.length),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _menu(String icon, String title) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(5),
          child: SvgPicture.asset(icon),
        ),
        Text(title, style: const TextStyle(color: AppColors.primaryColor)),
      ],
    );
  }
}
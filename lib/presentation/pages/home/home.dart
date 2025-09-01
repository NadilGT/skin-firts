import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_firts/common/widgets/doc_profile_card/doctor_profile_card.dart';
import 'package:skin_firts/common/widgets/searchBar/custom_search_bar.dart';
import 'package:skin_firts/core/constants/color_manager.dart';
import 'package:skin_firts/data/models/doctor_model/doctor_model.dart';

import 'widgets/calender_schedule_widget.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<DoctorModel> doctors = [
    DoctorModel(
      doctorName: "Dr. Olivia Turner, M.D.",
      specialty: "Dermato-Endocrinology",
      profilePic: "assets/images/profile.jpg",
      rating: 5.0,
      reviewCount: 60,
    ),
    DoctorModel(
      doctorName: "Dr. Ethan Johnson, M.D.",
      specialty: "Dermato-Endocrinology",
      profilePic: "assets/images/profile.jpg",
      rating: 5.0,
      reviewCount: 60,
    ),
    DoctorModel(
      doctorName: "Dr. Sophia Carter, M.D.",
      specialty: "Dermato-Endocrinology",
      profilePic: "assets/images/profile.jpg",
      rating: 5.0,
      reviewCount: 60,
    ),
    DoctorModel(
      doctorName: "Dr. Olivia Turner, M.D.",
      specialty: "Dermato-Endocrinology",
      profilePic: "assets/images/profile.jpg",
      rating: 5.0,
      reviewCount: 60,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 60, right: 30, left: 30),
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
                      _iconButton("assets/images/notification.svg"),
                      const SizedBox(width: 10),
                      _iconButton("assets/images/setting.svg"),
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
                  _menu("assets/images/doc.svg", "Doctors"),
                  const SizedBox(width: 15),
                  _menu("assets/images/fav.svg", "Favorite"),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: DoctorProfileCard(
                  doctorName: doctor.doctorName,
                  specialty: doctor.specialty,
                  imageUrl: doctor.profilePic,
                  rating: doctor.rating,
                  reviewCount: doctor.reviewCount,
                ),
              );
            }, childCount: doctors.length),
          ),
        ],
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

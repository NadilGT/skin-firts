import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/common/widgets/appBar/app_bar.dart';
import 'package:skin_firts/core/constants/color_manager.dart';
import 'package:skin_firts/presentation/pages/doctor_info/doctor_info.dart';
import 'package:skin_firts/presentation/pages/home/bloc/doctors_cubit.dart';
import 'package:skin_firts/presentation/pages/home/bloc/doctors_state.dart';

import '../../../data/models/doctor_info_model/doctor_info_model.dart';
import 'widgets/doctor_card.dart';

// ignore: must_be_immutable
class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  List<DoctorInfoModel> doctors = [];
  bool showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorsCubit()..getDoctors(),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text("Doctors"),
          action: Row(
            children: [
              _appBarIcon(Icons.search),
              SizedBox(width: 10),
              _appBarIcon(Icons.menu_open_sharp),
            ],
          ),
        ),
        body: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state is DoctorsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoctorsLoaded) {
              doctors = state.doctors;
            }

            final filteredDoctors = showFavoritesOnly
                ? doctors.where((doc) => doc.favorite == true).toList()
                : doctors;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Sort By"),
                      SizedBox(width: 5),
                      _appBarIconText("A--Z"),
                      SizedBox(width: 5),
                      _appBarIcon(Icons.star_border),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showFavoritesOnly = !showFavoritesOnly;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.lightBlue,
                          ),
                          child: Icon(
                            showFavoritesOnly
                                ? Icons
                                      .favorite
                                : Icons.favorite_border_rounded,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      _appBarIcon(Icons.girl_outlined),
                      SizedBox(width: 5),
                      _appBarIcon(Icons.boy),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = filteredDoctors[index];
                        return DoctorCard(
                          doctorName: doctor.name,
                          specialty: doctor.special,
                          imageUrl: doctor.profilePic,
                          rating: doctor.starts.toDouble(),
                          reviewCount: doctor.messages,
                          onclick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DoctorInfo(doctor: doctor),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _appBarIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightBlue,
      ),
      child: Icon(icon, color: AppColors.primaryColor),
    );
  }

  Widget _appBarIconText(String text) {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(40),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(color: AppColors.mainWhite),
        textAlign: TextAlign.center,
      ),
    );
  }
}

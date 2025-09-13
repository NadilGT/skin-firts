import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/domain/entity/doctor_info_entity/doctor_info_entity.dart';
import 'package:skin_firts/domain/usecases/toggle_favorite_usecase/toggle_favorite_usecase.dart';
import 'package:skin_firts/presentation/pages/doctor_info/bloc/doctor_info_cubit.dart';
import 'package:skin_firts/presentation/pages/doctor_info/bloc/doctor_info_state.dart';
import 'package:skin_firts/service_locator.dart';

import '../../../common/widgets/appBar/app_bar.dart';
import '../../../core/constants/color_manager.dart';
import '../../../core/storage/data_state.dart';
import '../../../data/models/doctor_info_model/doctor_info_model.dart';

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
    return BlocProvider(
      create: (context) => DoctorInfoCubit()..getDoctorInfo(widget.doctor.name),
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
        body: BlocBuilder<DoctorInfoCubit, DoctorInfoState>(
          builder: (context, state) {
            if (state is DoctorInfoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoctorInfoLoaded) {
              doctorInfo = state.doctorInfoEntity;
            }
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF6B9FFF), Color(0xFF4A7BFF)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    widget.doctor.profilePic,
                                  ),
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                              SizedBox(width: 16),
                              // Experience Badge
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.verified,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            doctorInfo?.experience.toString() ??
                                                "loading",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'experience',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Focus: ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        doctorInfo?.focus ?? "nothing",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 11,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Doctor Name and Specialization
                          Text(
                            doctorInfo?.name ?? "n/a",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            doctorInfo?.special ?? "",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 20),

                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              SizedBox(width: 4),
                              Text(
                                doctorInfo?.starts.toString() ?? "0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                doctorInfo?.messages.toString() ?? "0",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                doctorInfo?.date.toString() ?? "DD/MM/YYYY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Color(0xFF4A7BFF),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_today, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Schedule',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              _buildActionButton(Icons.info_outline, () {}),
                              SizedBox(width: 8),
                              _buildActionButton(Icons.share_outlined, () {}),
                              SizedBox(width: 8),
                              _buildActionButton(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
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
                                    } else {
                                      print(
                                        "Failed to toggle favorite: $updatedDoctor",
                                      );
                                    }
                                  } catch (e) {
                                    // ignore: avoid_print
                                    print("Error toggling favorite: $e");
                                  }
                                },
                                color: isFavorite ? Colors.red : Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInfoSection(
                      'Profile',
                      doctorInfo?.profile ?? "empty",
                    ),
                    SizedBox(height: 16),
                    _buildInfoSection(
                      'Career Path',
                      doctorInfo?.career ?? "empty",
                    ),
                    SizedBox(height: 16),
                    _buildInfoSection(
                      'Highlights',
                      doctorInfo?.highlights ?? "empty",
                    ),
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

  Widget _buildActionButton(
    IconData icon,
    VoidCallback onPressed, {
    Color? color,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color ?? Colors.white, size: 20),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }
}

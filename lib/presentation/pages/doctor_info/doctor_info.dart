import 'package:flutter/material.dart';
import 'package:skin_firts/domain/entity/doctor_entity/doctor_entity.dart';

class DoctorInfo extends StatelessWidget {
  final DoctorEntity doctor;
  const DoctorInfo({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(doctor.doctorName),
      ),
    );
  }
}
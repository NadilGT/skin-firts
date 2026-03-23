import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/focus_entity/focus_entity.dart';
import 'doctors_by_focus_cubit/doctors_by_focus_cubit.dart';
import 'doctors_by_focus_cubit/doctors_by_focus_state.dart';
import 'focus_bloc/focus_cubit.dart';
import 'focus_bloc/focus_state.dart';
import '../doctor_info/doctor_info.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentState();
}

class _AppointmentState extends State<AppointmentPage> {
  FocusEntity? selectedFocus;

  @override
  Widget build(BuildContext context) {
    // Basic colors based on theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    final inputFillColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade50;

    return MultiBlocProvider(
      providers: [
        // We will add more cubits here later
        BlocProvider(create: (context) => FocusCubit()..getAllFocus()),
        BlocProvider(create: (context) => DoctorsByFocusCubit()),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Book Appointment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: MultiBlocListener(
          listeners: [
            // Multibloc listeners as requested for listening to failure states / side effects
            BlocListener<FocusCubit, FocusState>(
              listener: (context, state) {
                if (state is FocusFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to load focus: ${state.error}'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            BlocListener<DoctorsByFocusCubit, DoctorsByFocusState>(
              listener: (context, state) {
                if (state is DoctorsByFocusFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to load doctors: ${state.error}'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Text(
                    "What do you need help with?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Select a primary focus for your appointment so we can match you with the right specialist.",
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dropdown Section inside a styled container
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            isDarkMode ? 0.3 : 0.05,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Select Focus',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<FocusCubit, FocusState>(
                          builder: (context, state) {
                            if (state is FocusLoading) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                ),
                              );
                            } else if (state is FocusLoaded) {
                              return DropdownButtonFormField<FocusEntity>(
                                decoration: InputDecoration(
                                  fillColor: inputFillColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: primaryColor,
                                ),
                                hint: Text(
                                  'Choose a focus...',
                                  style: TextStyle(color: subtitleColor),
                                ),
                                value: selectedFocus,
                                items: state.focusEntity.map((focus) {
                                  return DropdownMenuItem<FocusEntity>(
                                    value: focus,
                                    child: Text(
                                      focus.name ?? "Unknown",
                                      style: TextStyle(
                                        color: selectedFocus == focus
                                            ? primaryColor
                                            : textColor,
                                        fontWeight: selectedFocus == focus
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedFocus = value;
                                  });

                                  if (value != null) {
                                    context
                                        .read<DoctorsByFocusCubit>()
                                        .getAllDoctorsByFocus(
                                          selectedFocus!.name ?? "",
                                        );
                                  }
                                },
                              );
                            } else if (state is FocusFailed) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Failed to connect: ${state.error}',
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  BlocBuilder<DoctorsByFocusCubit, DoctorsByFocusState>(
                    builder: (context, state) {
                      if (state is DoctorsByFocusInitial) {
                        return const SizedBox();
                      } else if (state is DoctorsByFocusLoading) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(color: primaryColor),
                          ),
                        );
                      } else if (state is DoctorsByFocusLoaded) {
                        if (state.doctors.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Text(
                                "No doctors available for this focus.",
                                style: TextStyle(color: subtitleColor, fontSize: 16),
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.doctors.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final doctor = state.doctors[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorInfo(doctor: doctor),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: primaryColor.withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: primaryColor.withOpacity(0.1),
                                        backgroundImage: doctor.profile_pic.isNotEmpty
                                            ? NetworkImage(doctor.profile_pic)
                                            : null,
                                        child: doctor.profile_pic.isEmpty
                                            ? Icon(Icons.person, color: primaryColor)
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctor.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            doctor.special,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                (doctor.starts ?? 0.0).toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(Icons.work_outline, color: subtitleColor, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${doctor.experience ?? 0} Years",
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
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: subtitleColor,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is DoctorsByFocusFailed) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Failed to load doctors: ${state.error}',
                                  style: const TextStyle(color: Colors.red, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

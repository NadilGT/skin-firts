import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/focus_entity/focus_entity.dart';
import 'focus_bloc/focus_cubit.dart';
import 'focus_bloc/focus_state.dart';

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
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final inputFillColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50;

    return MultiBlocProvider(
      providers: [
        // We will add more cubits here later
        BlocProvider(
          create: (context) => FocusCubit()..getAllFocus(),
        ),
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
          ],
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                          color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
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
                            Icon(Icons.medical_services_outlined, color: primaryColor),
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
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator(color: primaryColor),
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
                                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                icon: Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
                                hint: Text('Choose a focus...', style: TextStyle(color: subtitleColor)),
                                value: selectedFocus,
                                items: state.focusEntity.map((focus) {
                                  return DropdownMenuItem<FocusEntity>(
                                    value: focus,
                                    child: Text(
                                      focus.name ?? "Unknown",
                                      style: TextStyle(
                                        color: selectedFocus == focus ? primaryColor : textColor,
                                        fontWeight: selectedFocus == focus ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedFocus = value;
                                  });
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
                                    const Icon(Icons.error_outline, color: Colors.red),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Failed to connect: ${state.error}',
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
                      ],
                    ),
                  ),

                  // Future components can be added safely below this spacing
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
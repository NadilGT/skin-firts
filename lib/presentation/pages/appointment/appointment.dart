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
    return MultiBlocProvider(
      providers: [
        // We will add more cubits here later
        BlocProvider(
          create: (context) => FocusCubit()..getAllFocus(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Appointment'),
        ),
        body: MultiBlocListener(
          listeners: [
            // Multibloc listeners as requested for listening to failure states / side effects
            BlocListener<FocusCubit, FocusState>(
              listener: (context, state) {
                if (state is FocusFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to load focus: ${state.error}')),
                  );
                }
              },
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Focus',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<FocusCubit, FocusState>(
                  builder: (context, state) {
                    if (state is FocusLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FocusLoaded) {
                      return DropdownButtonFormField<FocusEntity>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        hint: const Text('Choose a focus'),
                        value: selectedFocus,
                        items: state.focusEntity.map((focus) {
                          return DropdownMenuItem<FocusEntity>(
                            value: focus,
                            child: Text(focus.name ?? "Unknown"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFocus = value;
                          });
                        },
                      );
                    } else if (state is FocusFailed) {
                      return Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
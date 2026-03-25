import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/core/storage/data_state.dart';

import '../../../../data/models/appointment/appointment_model.dart';
import '../../../../domain/usecases/appointment_usecase/get_all_appointments_usecase.dart';
import 'appointments_state.dart';

class AppointmentCubits extends Cubit<AppointmentsState> {
  final GetAllAppointmentsUsecase _getAllAppointmentsUsecase;

  AppointmentCubits({
    required GetAllAppointmentsUsecase getAllAppointmentsUsecase,
  })  : _getAllAppointmentsUsecase = getAllAppointmentsUsecase,
        super(AppointmentInitial());

  Future<void> getAllAppointments({String? params}) async {
    final userId = params ?? FirebaseAuth.instance.currentUser?.uid ?? "";
    emit(AppointmentLoading());

    try {
      final result = await _getAllAppointmentsUsecase.call(params: userId);

      if (result is DataSuccess<PaginatedAppointmentsModel>) {
        final appointments = result.data?.appointments ?? [];
        emit(AppointmentLoaded(appointments: appointments));
      } else if (result is DataFailed) {
        emit(AppointmentError(
          message: result.error?.toString() ?? 'Failed to load appointments',
        ));
      }
    } catch (e) {
      emit(AppointmentError(message: e.toString()));
    }
  }

  Future<void> refreshAppointments() async {
    await getAllAppointments();
  }
}
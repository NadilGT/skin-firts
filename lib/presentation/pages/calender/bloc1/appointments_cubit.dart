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

  Future<void> getAllAppointments() async {
    emit(AppointmentLoading());

    try {
      final result = await _getAllAppointmentsUsecase.call();

      if (result is DataSuccess<List<AppointmentModel>>) {
        // result.data is already List<AppointmentModel>, no need to parse
        final appointments = result.data ?? [];
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
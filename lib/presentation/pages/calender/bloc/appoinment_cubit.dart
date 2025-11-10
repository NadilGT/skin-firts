import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/usecases/appointment_usecase/appointment_usecase.dart';
import 'package:skin_firts/service_locator.dart';

import '../../../../data/models/appointment/appointment_model.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());

  Future<void> createAppointment(AppointmentModel appointment) async {
    emit(AppointmentLoading());

    var result = await sl<AppointmentUsecase>().call(params: appointment);
    
    print("appointment cubit wada");
    
    if (result is DataSuccess) {
      print("appointment success");
      emit(AppointmentCreated(appointment: result.data!));
    } else if (result is DataFailed) {
      print("appointment failed");
      emit(AppointmentFailed(error: result.error ?? "Appointment creation failed"));
    }
  }

  // Method to fetch appointments (for future use)
  Future<void> fetchAppointments() async {
    emit(AppointmentLoading());
    
    // TODO: Implement fetch appointments when API is ready
    // For now, return empty list
    emit(AppointmentsFetched(appointments: []));
  }

  // Method to cancel appointment (for future use)
  Future<void> cancelAppointment(String appointmentId) async {
    emit(AppointmentLoading());
    
    // TODO: Implement cancel appointment when API is ready
    emit(AppointmentCancelled(message: "Appointment cancelled successfully"));
  }
}
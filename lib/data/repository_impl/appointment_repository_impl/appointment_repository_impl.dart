// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/domain/entity/appointment_entity/appointment_entity.dart';
import 'package:skin_firts/domain/repositories/appointment_repository/appointment_repository.dart';
import 'package:skin_firts/domain/service/api/api_service.dart';
import 'package:skin_firts/service_locator.dart';

import 'package:skin_firts/core/storage/shared_pref_manager.dart';

import '../../models/appointment/appointment_model.dart';
import '../../models/next_appointment_number_model/next_appointment_number_model.dart';
import '../../models/running_appointment_number_model/running_appointment_number_model.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final ApiService apiService = sl<ApiService>();
  final SharedPrefManager sharedPrefManager = sl<SharedPrefManager>();

  @override
  Future<DataState<Appointment>> createAppointment(
    AppointmentModel appointment,
  ) async {
    print("appointment repo wada");
    try {
      final branchId = await sharedPrefManager.getBranchId();
      
      final appointmentWithBranch = AppointmentModel(
        id: appointment.id,
        createdAt: appointment.createdAt,
        updatedAt: appointment.updatedAt,
        appointmentId: appointment.appointmentId,
        appointmentNumber: appointment.appointmentNumber,
        patientId: appointment.patientId,
        patientName: appointment.patientName,
        patientEmail: appointment.patientEmail,
        patientPhone: appointment.patientPhone,
        doctorId: appointment.doctorId,
        doctorName: appointment.doctorName,
        doctorSpecialty: appointment.doctorSpecialty,
        appointmentDate: appointment.appointmentDate,
        notes: appointment.notes,
        status: appointment.status,
        branchId: branchId,
      );

      final httpResponse = await apiService.createAppointment(appointmentWithBranch);
      print("Response status: ${httpResponse.response.statusCode}");
      print("Response data: ${httpResponse.data}");

      if (httpResponse.response.statusCode == 201 ||
          httpResponse.response.statusCode == 200) {
        final responseData = httpResponse.data;

        // ignore: unnecessary_type_check, unnecessary_null_comparison
        if (responseData != null && responseData is Map<String, dynamic>) {
          if (responseData.containsKey('appointment')) {
            final appointmentData =
                responseData['appointment'] as Map<String, dynamic>;

            final createdAppointment = AppointmentModel.fromJson(
              appointmentData,
            );

            return DataSuccess(createdAppointment);
          } else {
            final createdAppointment = AppointmentModel.fromJson(responseData);
            return DataSuccess(createdAppointment);
          }
        // ignore: dead_code
        } else {
          return DataFailed("Invalid response format");
        }
      } else {
        print("Error response: ${httpResponse.response}");
        return DataFailed(
          "Data Fetching Failed - Status: ${httpResponse.response.statusCode}",
        );
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      print("Response: ${e.response?.data}");
      return DataFailed(
        e.response?.data?.toString() ?? e.message ?? "Unknown error",
      );
    } catch (e) {
      print("Exception: $e");
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<PaginatedAppointmentsModel>> getAllAppointments(String patientId, String? branchId) async {
    try {
      final response = await apiService.getAllAppointments(patientId, branchId);
      
      if (response.response.statusCode == 200) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          'Failed to fetch appointments - Status: ${response.response.statusCode} - ${response.response.statusMessage ?? ''}',
        );
      }
    } on DioException catch (e) {
      return DataFailed(
        e.response?.data?.toString() ?? e.message ?? "Unknown error",
      );
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<NextAppointmentNumberModel>> getNextAppointmentNumber(
    String doctorId,
    String date,
    String? branchId,
  ) async {
    try {
      final response = await apiService.getNextAppointmentNumber(
        doctorId,
        date,
        branchId,
      );
      
      if (response.response.statusCode == 200) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          'Failed to fetch next appointment number - Status: ${response.response.statusCode} - ${response.response.statusMessage ?? ''}',
        );
      }
    } on DioException catch (e) {
      return DataFailed(
        e.response?.data?.toString() ?? e.message ?? "Unknown error",
      );
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<RunningAppointmentNumberModel>> getRunningAppointmentNumber(
    String doctorId,
    String date,
  ) async {
    try {
      final response = await apiService.getRunningAppointmentNumber(
        doctorId,
        date,
      );
      
      if (response.response.statusCode == 200) {
        return DataSuccess(response.data);
      } else {
        return DataFailed(
          'Failed to fetch running appointment number - Status: ${response.response.statusCode} - ${response.response.statusMessage ?? ''}',
        );
      }
    } on DioException catch (e) {
      return DataFailed(
        e.response?.data?.toString() ?? e.message ?? "Unknown error",
      );
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
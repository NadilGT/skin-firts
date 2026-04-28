import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:skin_firts/core/constants/api_constants.dart';
import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';
import '../../../data/models/appointment/appointment_model.dart';
import '../../../data/models/branch_model/branch_model.dart';
import '../../../data/models/doctor_availability_model/doctor_availability_model.dart';
import '../../../data/models/doctor_schedule_model/doctor_schedule_model.dart';
import '../../../data/models/find_role_model/find_role_model.dart';
import '../../../data/models/focus_model/focus_model.dart';
import '../../../data/models/next_appointment_number_model/next_appointment_number_model.dart';
import '../../../data/models/notification_model/notification_model.dart';
import '../../../data/models/register_user_model/register_user_model.dart';
import '../../../data/models/running_appointment_number_model/running_appointment_number_model.dart';
import '../../../data/models/save_fcm_token_model/save_fcm_token_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseURL)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET('/doctors')
  Future<HttpResponse<List<DoctorInfoModel>>> getAllDoctors();

  @GET("/doctor-info/id")
  Future<HttpResponse<DoctorInfoModel>> getDoctorInfo(
    @Query("doctor_id") String doctorId,
  );

  @PUT("/doctor-info/favorite")
  Future<HttpResponse<DoctorInfoModel>> toggleFavorite(
    @Query("name") String name,
  );

  @POST('/create/appointment')
  Future<HttpResponse<dynamic>> createAppointment(
    @Body() AppointmentModel appointment,
  );

  @GET('/findAll/appointments/patient')
  Future<HttpResponse<PaginatedAppointmentsModel>> getAllAppointments(
    @Query("patientId") String patientId,
    @Query("branchId") String? branchId,
  );

  @GET('/findAll/focus')
  Future<HttpResponse<List<FocusModel>>> getAllFocus();

  @GET('/findAll/doctors/focus')
  Future<HttpResponse<List<DoctorInfoModel>>> getAllDoctorsByFocus(
    @Query("focusId") String focusId,
    @Query("branchId") String? branchId,
  );

  @GET('/appointment/next-number/doctorId')
  Future<HttpResponse<NextAppointmentNumberModel>> getNextAppointmentNumber(
    @Query("doctorId") String doctorId,
    @Query("date") String date,
    @Query("branchId") String? branchId,
  );

  @POST('/register/patient')
  Future<HttpResponse<RegisterUserResponseModel>> registerPatient(
    @Body() RegisterUserModel registerUserModel,
  );

  @GET('/role/mobile')
  Future<HttpResponse<FindRoleResponseModel>> findRole(
    @Query("firebaseUid") String firebaseUid,
  );

  @GET('/appointments/running/doctorId')
  Future<HttpResponse<RunningAppointmentNumberModel>> getRunningAppointmentNumber(
    @Query("doctorId") String doctorId,
    @Query("date") String date,
  );

  @GET('/doctor-weekly-schedule/available-dates')
  Future<HttpResponse<DoctorScheduleResponseModel>> getDoctorSchedule(
    @Query("doctorId") String doctorId,
    @Query("branchId") String? branchId,
  );

  @GET('/doctor-availability/check')
  Future<HttpResponse<DoctorAvailabilityModel>> getDoctorAvailability(
    @Query("doctorId") String doctorId,
    @Query("date") String date,
    @Query("branchId") String? branchId,
  );

  @POST('/api/users/save-token')
  Future<HttpResponse<dynamic>> saveFcmToken(
    @Body() SaveFcmTokenModel saveFcmTokenModel,
  );

  @GET('/api/notifications')
  Future<HttpResponse<NotificationPaginationResponseModel>> getNotifications(
    @Query("userId") String userId,
    @Query("lastId") String? lastId,
    @Query("limit") int limit,
  );

  @GET('/branches')
  Future<HttpResponse<BranchResponseModel>> findAllBranches(
    @Query("status") String? status,
  );
}

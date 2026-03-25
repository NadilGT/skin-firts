import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:skin_firts/core/constants/api_constants.dart';
import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';
import '../../../data/models/appointment/appointment_model.dart';
import '../../../data/models/find_role_model/find_role_model.dart';
import '../../../data/models/focus_model/focus_model.dart';
import '../../../data/models/next_appointment_number_model/next_appointment_number_model.dart';
import '../../../data/models/register_user_model/register_user_model.dart';
import '../../../data/models/running_appointment_number_model/running_appointment_number_model.dart';
import '../../entity/running_appointment_number_entity/running_appointment_number_entity.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseURL)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET('/doctors')
  Future<HttpResponse<List<DoctorInfoModel>>> getAllDoctors();

  @GET("/doctor-info")
  Future<HttpResponse<DoctorInfoModel>> getDoctorInfo(
    @Query("name") String name,
  );

  @PUT("/doctor-info/favorite")
  Future<HttpResponse<DoctorInfoModel>> toggleFavorite(
    @Query("name") String name,
  );

  @POST('/create/appointment')
  Future<HttpResponse<dynamic>> createAppointment(
    @Body() AppointmentModel appointment,
  );

  @GET('/findAll/appointments')
  Future<HttpResponse<PaginatedAppointmentsModel>> getAllAppointments();

  @GET('/findAll/focus')
  Future<HttpResponse<List<FocusModel>>> getAllFocus();

  @GET('/findAll/doctors/focus')
  Future<HttpResponse<List<DoctorInfoModel>>> getAllDoctorsByFocus(
    @Query("focus") String focus,
  );

  @GET('/appointment/next-number/doctorId')
  Future<HttpResponse<NextAppointmentNumberModel>> getNextAppointmentNumber(
    @Query("doctorId") String doctorId,
    @Query("date") String date,
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
}

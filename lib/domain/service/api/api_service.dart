import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';
import '../../../data/models/appointment/appointment_model.dart';
import '../../entity/appointment_entity/appointment_entity.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://10.190.93.75:3000")
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
  Future<HttpResponse<Map<String, dynamic>>> createAppointment(
    @Body() AppointmentModel appointment,
  );

  @GET('/findAll/appointments')
  Future<HttpResponse<List<AppointmentModel>>> getAllAppointments();
}

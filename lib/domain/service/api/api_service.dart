import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:skin_firts/data/models/doctor_info_model/doctor_info_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://10.197.161.75:3000")
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
}

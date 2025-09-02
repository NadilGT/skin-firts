import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:skin_firts/data/models/doctor_model/doctor_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://10.47.201.150:3000")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/doctors')
  Future<HttpResponse<List<DoctorModel>>> getAllDoctors();
}
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../data/models/doctor_schedule/DoctorScheduleResponse.dart';

class DoctorScheduleRepository {
  final String baseUrl;

  DoctorScheduleRepository({required this.baseUrl});

  // Fetch doctor schedule by doctor name
  Future<DoctorScheduleResponse> getDoctorSchedule(String doctorName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doctor-schedule?doctorName=$doctorName'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DoctorScheduleResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load doctor schedule: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching doctor schedule: $e');
    }
  }

  // Fetch doctor schedule by date range
  Future<DoctorScheduleResponse> getDoctorScheduleByDateRange({
    required String doctorName,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      final endDateStr = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/doctor-schedule/range?doctorName=$doctorName&startDate=$startDateStr&endDate=$endDateStr'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DoctorScheduleResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load doctor schedule: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching doctor schedule: $e');
    }
  }
}
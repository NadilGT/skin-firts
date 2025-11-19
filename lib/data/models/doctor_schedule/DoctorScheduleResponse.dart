// ignore: file_names
class DoctorScheduleResponse {
  final String doctorName;
  final Map<DateTime, List<String>> schedules;

  DoctorScheduleResponse({
    required this.doctorName,
    required this.schedules,
  });

  factory DoctorScheduleResponse.fromJson(Map<String, dynamic> json) {
    // Convert the schedules map from String keys to DateTime keys
    Map<DateTime, List<String>> schedulesMap = {};
    
    if (json['schedules'] != null) {
      Map<String, dynamic> schedulesJson = json['schedules'] as Map<String, dynamic>;
      
      schedulesJson.forEach((dateStr, timeSlots) {
        // Parse the date string (YYYY-MM-DD format from backend)
        DateTime date = DateTime.parse(dateStr);
        // Normalize to midnight for consistency
        DateTime normalizedDate = DateTime(date.year, date.month, date.day);
        
        schedulesMap[normalizedDate] = List<String>.from(timeSlots);
      });
    }

    return DoctorScheduleResponse(
      doctorName: json['doctorName'] ?? '',
      schedules: schedulesMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> schedulesJson = {};
    
    schedules.forEach((date, timeSlots) {
      String dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      schedulesJson[dateStr] = timeSlots;
    });

    return {
      'doctorName': doctorName,
      'schedules': schedulesJson,
    };
  }
}
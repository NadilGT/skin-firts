import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/appointment_entity/appointment_entity.dart';

part 'appointment_model.g.dart';

@JsonSerializable()
class AppointmentModel extends Appointment {
  @JsonKey(includeFromJson: true, includeToJson: false)
  final String? id;

  @JsonKey(includeFromJson: true, includeToJson: false)
  final DateTime? createdAt;
  
  @JsonKey(includeFromJson: true, includeToJson: false)
  final DateTime? updatedAt;

  @override
  @JsonKey(toJson: _dateToJson, fromJson: _dateFromJson)
  final DateTime appointmentDate;

  const AppointmentModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    required super.appointmentId,
    required super.appointmentNumber,
    required super.patientId,
    required super.patientName,
    required super.patientEmail,
    super.patientPhone,
    required super.doctorId,
    required super.doctorName,
    super.doctorSpecialty,
    required this.appointmentDate,
    super.notes,
    super.status = 'pending',
  }) : super(appointmentDate: appointmentDate);

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}

String _dateToJson(DateTime date) => date.toIso8601String().split('T')[0];
DateTime _dateFromJson(String date) => DateTime.parse(date);


class PaginatedAppointmentsModel extends PaginatedAppointments {
  const PaginatedAppointmentsModel({
    required super.data,
    required super.limit,
    required super.page,
    required super.total,
    required super.totalPages,
  });

  // Returns data as the more specific List<AppointmentModel> type
  List<AppointmentModel> get appointments =>
      data.cast<AppointmentModel>();

  factory PaginatedAppointmentsModel.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>)
        .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedAppointmentsModel(
      data: dataList,
      limit: (json['limit'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );
  }
}
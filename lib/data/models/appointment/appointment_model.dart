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

  const AppointmentModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    required super.patientId,
    required super.patientName,
    required super.patientEmail,
    super.patientPhone,
    required super.doctorId,
    required super.doctorName,
    super.doctorSpecialty,
    required super.appointmentDate,
    required super.timeSlot,
    super.notes,
    super.status = 'pending',
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}
import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/running_appointment_number_entity/running_appointment_number_entity.dart';

part 'running_appointment_number_model.g.dart';

@JsonSerializable()
class RunningAppointmentNumberModel extends RunningAppointmentNumberEntity {

  const RunningAppointmentNumberModel({required super.running_appointment_number});

  factory RunningAppointmentNumberModel.fromJson(Map<String, dynamic> json) =>
      _$RunningAppointmentNumberModelFromJson(json);

  Map<String, dynamic> toJson() => _$RunningAppointmentNumberModelToJson(this);
}

@JsonSerializable()
class RunningAppointmentNumberParamsModel extends RunningAppointmentNumberParams {
  const RunningAppointmentNumberParamsModel({
    required String doctorId,
    required String date,
  }) : super(doctorId: doctorId, date: date);

  factory RunningAppointmentNumberParamsModel.fromJson(Map<String, dynamic> json) =>
      _$RunningAppointmentNumberParamsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RunningAppointmentNumberParamsModelToJson(this);
}

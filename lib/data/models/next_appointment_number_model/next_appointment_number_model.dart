import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/next_appointment_number_entity/next_appointment_number_entity.dart';

part 'next_appointment_number_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NextAppointmentNumberModel extends NextAppointmentNumberEntity {
  const NextAppointmentNumberModel({required super.nextAppointmentNumber});

  factory NextAppointmentNumberModel.fromJson(Map<String, dynamic> json) =>
      _$NextAppointmentNumberModelFromJson(json);
  Map<String, dynamic> toJson() => _$NextAppointmentNumberModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/focus_entity/focus_entity.dart';

part 'focus_model.g.dart';

@JsonSerializable()
class FocusModel extends FocusEntity {
  FocusModel({required super.id, required super.focusId, required super.name});

  factory FocusModel.fromJson(Map<String, dynamic> json) =>
      _$FocusModelFromJson(json);
  Map<String, dynamic> toJson() => _$FocusModelToJson(this);
}

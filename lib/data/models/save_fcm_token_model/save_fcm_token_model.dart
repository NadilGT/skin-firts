import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/save_fcm_token_entity/save_fcm_token_entity.dart';

part 'save_fcm_token_model.g.dart';

@JsonSerializable()
class SaveFcmTokenModel extends SaveFcmTokenEntity {
  const SaveFcmTokenModel({required super.userId, required super.fcmToken});

  factory SaveFcmTokenModel.fromJson(Map<String, dynamic> json) =>
      _$SaveFcmTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaveFcmTokenModelToJson(this);
}
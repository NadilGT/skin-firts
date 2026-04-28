import 'package:json_annotation/json_annotation.dart';
import 'package:skin_firts/domain/entity/notification_entity/notification_entity.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationParamsModel extends NotificationParamsEntity {
  const NotificationParamsModel({
    required super.userId,
    super.lastId,
    required super.limit,
  });

  factory NotificationParamsModel.fromJson(Map<String, dynamic> json) => _$NotificationParamsModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationParamsModelToJson(this);
}


@JsonSerializable()
class NotificationResponseModel extends NotificationResponseEntity {
  const NotificationResponseModel({
    required super.id,
    required super.notificationId,
    required super.userId,
    required super.title,
    required super.body,
    required super.type,
    required super.data,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => _$NotificationResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationResponseModelToJson(this);
}

@JsonSerializable()
class NotificationPaginationResponseModel extends NotificationPaginationResponseEntity {
  @override
  final List<NotificationResponseModel>? notifications;

  const NotificationPaginationResponseModel({
    this.notifications,
    required super.nextCursor,
  }) : super(notifications: notifications);

  factory NotificationPaginationResponseModel.fromJson(Map<String, dynamic> json) => _$NotificationPaginationResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPaginationResponseModelToJson(this);
}
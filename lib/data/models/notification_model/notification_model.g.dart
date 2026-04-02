// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationParamsModel _$NotificationParamsModelFromJson(
  Map<String, dynamic> json,
) => NotificationParamsModel(
  userId: json['userId'] as String,
  lastId: json['lastId'] as String?,
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$NotificationParamsModelToJson(
  NotificationParamsModel instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'lastId': instance.lastId,
  'limit': instance.limit,
};

NotificationResponseModel _$NotificationResponseModelFromJson(
  Map<String, dynamic> json,
) => NotificationResponseModel(
  id: json['id'] as String,
  notificationId: json['notificationId'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  type: json['type'] as String,
  data: json['data'] as Map<String, dynamic>,
  isRead: json['isRead'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$NotificationResponseModelToJson(
  NotificationResponseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'notificationId': instance.notificationId,
  'userId': instance.userId,
  'title': instance.title,
  'body': instance.body,
  'type': instance.type,
  'data': instance.data,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
};

NotificationPaginationResponseModel
_$NotificationPaginationResponseModelFromJson(Map<String, dynamic> json) =>
    NotificationPaginationResponseModel(
      notifications: (json['notifications'] as List<dynamic>)
          .map(
            (e) =>
                NotificationResponseModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );

Map<String, dynamic> _$NotificationPaginationResponseModelToJson(
  NotificationPaginationResponseModel instance,
) => <String, dynamic>{
  'nextCursor': instance.nextCursor,
  'notifications': instance.notifications,
};

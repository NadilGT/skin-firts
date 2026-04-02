import 'package:equatable/equatable.dart';

class NotificationParamsEntity extends Equatable {
  final String userId;
  final String? lastId;
  final int limit;

  const NotificationParamsEntity({
    required this.userId,
    this.lastId,
    required this.limit,
  });
  
  @override
  List<Object?> get props => [userId, lastId, limit];
}

class NotificationResponseEntity extends Equatable {
  final String id;
  final String notificationId;
  final String userId;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationResponseEntity({
    required this.id,
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [id, notificationId, userId, title, body, type, data, isRead, createdAt];
}

class NotificationPaginationResponseEntity extends Equatable {
  final String? nextCursor;
  final List<NotificationResponseEntity> notifications;

  const NotificationPaginationResponseEntity({
    required this.notifications,
    required this.nextCursor,
  });
  
  @override
  List<Object?> get props => [notifications, nextCursor];
}


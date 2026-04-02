import '../../../../data/models/notification_model/notification_model.dart';

abstract class GetNotificationsState {}

class GetNotificationsInitial extends GetNotificationsState {}

class GetNotificationsLoading extends GetNotificationsState {}

class GetNotificationsLoaded extends GetNotificationsState {
  final List<NotificationResponseModel> notifications;
  final String? nextCursor;
  final bool isLoadingMore;
  final bool hasReachedEnd;

  GetNotificationsLoaded({
    required this.notifications,
    required this.nextCursor,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
  });

  GetNotificationsLoaded copyWith({
    List<NotificationResponseModel>? notifications,
    String? nextCursor,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) {
    return GetNotificationsLoaded(
      notifications: notifications ?? this.notifications,
      nextCursor: nextCursor ?? this.nextCursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class GetNotificationsFailed extends GetNotificationsState {
  final String error;

  GetNotificationsFailed({required this.error});
}
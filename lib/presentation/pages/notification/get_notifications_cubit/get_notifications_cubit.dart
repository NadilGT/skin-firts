import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/domain/usecases/get_notofication_usecase/get_notofication_usecase.dart';
import 'package:skin_firts/presentation/pages/notification/get_notifications_cubit/get_notifications_state.dart';
import 'package:skin_firts/service_locator.dart';

import '../../../../core/storage/data_state.dart';
import '../../../../data/models/notification_model/notification_model.dart';

class GetNotificationsCubit extends Cubit<GetNotificationsState> {
  GetNotificationsCubit() : super(GetNotificationsInitial());

  final getNotoficationUsecase = sl<GetNotoficationUsecase>();

  bool isFetching = false;

  /// 🔹 Initial Load
  Future<void> getNotifications({required String userId}) async {
    if (isFetching) return;

    isFetching = true;
    emit(GetNotificationsLoading());

    final result = await getNotoficationUsecase.call(
      params: NotificationParamsModel(
        userId: userId,
        limit: 10,
        lastId: null, // ✅ IMPORTANT
      ),
    );

    isFetching = false;

    if (result is DataSuccess) {
      final data = result.data!;

      emit(GetNotificationsLoaded(
        notifications: data.notifications ?? [],
        nextCursor: data.nextCursor,
        hasReachedEnd: data.nextCursor == null || data.nextCursor!.isEmpty,
      ));
    } else {
      emit(GetNotificationsFailed(
        error: result.error ?? "Failed to get notifications",
      ));
    }
  }

  /// 🔹 Load More (Pagination)
  Future<void> loadMore({required String userId}) async {
    final currentState = state;

    if (currentState is! GetNotificationsLoaded) return;
    if (currentState.hasReachedEnd) return;
    if (isFetching) return;

    isFetching = true;

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await getNotoficationUsecase.call(
      params: NotificationParamsModel(
        userId: userId,
        limit: 10,
        lastId: currentState.nextCursor, // ✅ CURSOR USED HERE
      ),
    );

    isFetching = false;

    if (result is DataSuccess) {
      final data = result.data!;

      final updatedList = [
        ...currentState.notifications,
        ...?data.notifications,
      ];

      emit(currentState.copyWith(
        notifications: updatedList,
        nextCursor: data.nextCursor,
        isLoadingMore: false,
        hasReachedEnd: data.nextCursor == null || data.nextCursor!.isEmpty,
      ));
    } else {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}
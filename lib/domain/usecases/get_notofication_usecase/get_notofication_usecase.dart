import 'package:skin_firts/core/storage/data_state.dart';
import 'package:skin_firts/data/models/notification_model/notification_model.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';
import 'package:skin_firts/service_locator.dart';

import '../../repositories/notification_repository/notification_repository.dart';

class GetNotoficationUsecase extends UseCase<DataState<NotificationPaginationResponseModel>, NotificationParamsModel>{
  @override
  Future<DataState<NotificationPaginationResponseModel>> call({NotificationParamsModel? params}) {
    return sl<NotificationRepository>().getNotifications(
      params!.userId,
      params.lastId,
      params.limit,
    );
  }
}
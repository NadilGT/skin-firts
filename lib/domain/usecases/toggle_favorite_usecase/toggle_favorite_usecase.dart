import 'package:skin_firts/domain/repositories/toggle_favorite_repository/toggle_favorite_repository.dart';
import 'package:skin_firts/domain/usecases/usecase/usecase.dart';

import '../../../service_locator.dart';

class ToggleFavoriteUsecase implements UseCase{
  @override
  Future call({params}) {
    return sl<ToggleFavoriteRepository>().toggleFavDoc(params);
  }
}
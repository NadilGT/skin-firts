import 'package:equatable/equatable.dart';

class SaveFcmTokenEntity extends Equatable{
  final String userId;
  final String fcmToken;

  const SaveFcmTokenEntity({required this.userId, required this.fcmToken});

  @override
  List<Object?> get props => [userId, fcmToken];
}
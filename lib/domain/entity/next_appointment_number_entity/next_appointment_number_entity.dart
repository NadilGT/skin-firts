import 'package:equatable/equatable.dart';

class NextAppointmentNumberEntity extends Equatable{
  final int nextAppointmentNumber;

  const NextAppointmentNumberEntity({required this.nextAppointmentNumber});

  @override
  List<Object?> get props => [nextAppointmentNumber];
}
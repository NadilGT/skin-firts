import 'package:equatable/equatable.dart';

class FocusEntity extends Equatable {
  final String? id;
  final String? focusId;
  final String? name;

  const FocusEntity({
    required this.id,
    required this.focusId,
    required this.name,
  });

  @override
  List<Object?> get props => [id, focusId, name];
}

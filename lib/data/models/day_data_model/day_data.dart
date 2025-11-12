class DayData {
  final int day;
  final String weekday;
  bool isSelected;
  final DateTime? fullDate;

  DayData({
    required this.day,
    required this.weekday,
    this.isSelected = false,
    this.fullDate,
  });

  DayData copyWith({
    int? day,
    String? weekday,
    bool? isSelected,
    DateTime? fullDate,
  }) {
    return DayData(
      day: day ?? this.day,
      weekday: weekday ?? this.weekday,
      isSelected: isSelected ?? this.isSelected,
      fullDate: fullDate ?? this.fullDate,
    );
  }
}
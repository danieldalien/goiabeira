enum TimeWindow {
  today,
  last7Days,
  last30Days,
  thisWeek,
  thisMonth,
  thisYear,
  allTime,
  custom,
}

extension TimeWindowExtension on TimeWindow {
  String get displayName {
    switch (this) {
      case TimeWindow.today:
        return 'Today';
      case TimeWindow.last7Days:
        return 'Last 7 Days';
      case TimeWindow.last30Days:
        return 'Last 30 Days';
      case TimeWindow.thisWeek:
        return 'This Week';
      case TimeWindow.thisMonth:
        return 'This Monthxs';
      case TimeWindow.thisYear:
        return 'This Year';
      case TimeWindow.allTime:
        return 'All Time';
      case TimeWindow.custom:
        return 'Custom';
    }
  }
}

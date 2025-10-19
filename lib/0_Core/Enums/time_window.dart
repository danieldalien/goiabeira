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
        return 'This Months';
      case TimeWindow.thisYear:
        return 'This Year';
      case TimeWindow.allTime:
        return 'All Time';
      case TimeWindow.custom:
        return 'Custom';
    }
  }
}

extension TimeWindowRange on TimeWindow {
  /// Returns a concrete [start, end] DateTime range for the given window.
  /// All times are in local time.
  (DateTime start, DateTime end)? getRange() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    switch (this) {
      case TimeWindow.today:
        return (todayStart, now);
      case TimeWindow.last7Days:
        return (now.subtract(const Duration(days: 7)), now);
      case TimeWindow.last30Days:
        return (now.subtract(const Duration(days: 30)), now);
      case TimeWindow.thisWeek:
        final weekday = now.weekday;
        final startOfWeek = todayStart.subtract(Duration(days: weekday - 1));
        return (startOfWeek, now);
      case TimeWindow.thisMonth:
        final startOfMonth = DateTime(now.year, now.month);
        return (startOfMonth, now);
      case TimeWindow.thisYear:
        final startOfYear = DateTime(now.year);
        return (startOfYear, now);
      case TimeWindow.allTime:
        // Represent as "no filtering"
        return null;
      case TimeWindow.custom:
        // Must be handled elsewhere (user-supplied)
        return null;
    }
  }
}

import 'package:goiabeira/0_Core/Enums/date_granularity.dart';

class DateTimeUtility {
  static DateTime getFirstDayOfMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

    return removeTime(firstDayOfMonth);
  }

  static DateTime getFirstDayOfWeek() {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return removeTime(firstDayOfWeek);
  }

  static DateTime removeTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static
  /// Returns the period corresponding to [granularity]:
  /// - year → the year (e.g. 2025)
  /// - month → the month index 1–12
  /// - week → week-of-month 1–5
  /// - day → the DateTime truncated to YYYY-MM-DD
  /// - quarter → 1–4
  /// - halfYear → 1 (Jan–Jun) or 2 (Jul–Dec)
  /// - decade → start year of the decade (e.g. 2020)
  /// - century → start year of the century (e.g. 2000)
  /// - millennium → start year of the millennium (e.g. 2000)
  Object
  getPeriod(DateTime date, DateGranularity granularity) {
    switch (granularity) {
      case DateGranularity.year:
        return date.year;

      case DateGranularity.month:
        return date.month;

      case DateGranularity.week:
        return isoWeekOfYear(date);

      case DateGranularity.day:
        // Return a DateTime with time zeroed out
        return DateTime(date.year, date.month, date.day);

      case DateGranularity.quarter:
        // Q1 = Jan–Mar, Q2 = Apr–Jun, etc.
        return ((date.month - 1) ~/ 3) + 1;

      case DateGranularity.halfYear:
        // 1 = Jan–Jun, 2 = Jul–Dec
        return date.month <= 6 ? 1 : 2;

      case DateGranularity.decade:
        // e.g. 2025 → 2020
        return (date.year ~/ 10) * 10;

      case DateGranularity.century:
        // e.g. 2025 → 2000
        return (date.year ~/ 100) * 100;

      case DateGranularity.millennium:
        // e.g. 2025 → 2000
        return (date.year ~/ 1000) * 1000;
    }
  }

  /// Returns the ISO week‐of‐year for [date], i.e. 1–52 (or 53 in some years).
  static int isoWeekOfYear(DateTime date) {
    // 1) Find the Thursday of this week, to anchor ISO rules
    final int dow = date.weekday; // Mon=1 … Sun=7
    final DateTime nearestThu = date.add(Duration(days: 4 - dow));

    // 2) Compute day‐of‐year of that Thursday
    final DateTime yearStart = DateTime(nearestThu.year, 1, 1);
    final int dayOfYear = nearestThu.difference(yearStart).inDays + 1;

    // 3) ISO week number = ceil(dayOfYear / 7)
    return (dayOfYear + 6) ~/ 7;
  }
}

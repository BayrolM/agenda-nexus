import 'package:intl/intl.dart';

abstract class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dayFormat = DateFormat('dd');
  static final DateFormat _monthFormat = DateFormat('MMM', 'es');
  static final DateFormat _fullDateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _fullDateWithTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _dayNameFormat = DateFormat('EEEE', 'es');

  static String formatDay(DateTime date) => _dayFormat.format(date);
  static String formatMonth(DateTime date) => _monthFormat.format(date);
  static String formatFull(DateTime date) => _fullDateFormat.format(date);
  static String formatFullWithTime(DateTime date) => _fullDateWithTimeFormat.format(date);
  static String formatDayName(DateTime date) => _dayNameFormat.format(date);

  static String formatCurrency(double amount, {String currencyCode = 'COP'}) {
    final format = NumberFormat.currency(locale: 'es_CO', symbol: '\$', name: currencyCode);
    return format.format(amount);
  }

  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static bool isPastDue(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.isBefore(today);
  }

  static String getRelativeDate(DateTime date) {
    if (isToday(date)) return 'Hoy';
    if (isTomorrow(date)) return 'Mañana';
    final days = daysUntil(date);
    if (days < 0) return 'Hace ${-days} días';
    if (days == 1) return 'En 1 día';
    return 'En $days días';
  }

  static DateTime getNextBillingDate(int billingDay) {
    final now = DateTime.now();
    var nextDate = DateTime(now.year, now.month, billingDay);

    if (nextDate.isBefore(now)) {
      nextDate = DateTime(now.year, now.month + 1, billingDay);
    }

    return nextDate;
  }
}

import 'package:intl/intl.dart';

class DateFormatter {
  static String fullDate(DateTime dt) {
    return DateFormat('EEEE, dd MMMM yyyy').format(dt);
  }

  static String hour(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  static String dayName(DateTime dt) {
    return DateFormat('EEE').format(dt);
  }
}

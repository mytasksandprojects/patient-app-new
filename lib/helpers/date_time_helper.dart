import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class DateTimeHelper {
  static String _convertArabicNumbersToEnglish(String input) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabicDigits.length; i++) {
      input = input.replaceAll(arabicDigits[i], englishDigits[i]);
    }

    return input;
  }

  static DateTime _parseDateWithArabicSupport(String dateString) {
    try {
      final englishDateString = _convertArabicNumbersToEnglish(dateString);
      try {
        return DateTime.parse(englishDateString);
      } catch (_) {
        final formats = [
          DateFormat('yyyy-MM-dd'),
          DateFormat('dd/MM/yyyy'),
          DateFormat('MM/dd/yyyy'),
        ];
        
        for (final format in formats) {
          try {
            return format.parse(englishDateString);
          } catch (_) {}
        }
        throw FormatException('Unsupported date format: $dateString');
      }
    } catch (e) {
      debugPrint('Error parsing date: $dateString');
      throw FormatException('Failed to parse date: $dateString');
    }
  }

  static DateTime safeParseDate(String dateString) {
    try {
      return _parseDateWithArabicSupport(dateString);
    } catch (e) {
      debugPrint('Error in safeParseDate: $e');
      return DateTime.now(); 
    }
  }

  static String getDataFormatWithTime(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return "";

    try {
      final newData = _parseDateWithArabicSupport(createdAt);
      return "${newData.day} ${getMonthName(newData.month)}, ${newData.year} ${formattedTime(newData)}";
    } catch (e) {
      debugPrint('Error in getDataFormatWithTime: $e');
      return "";
    }
  }

  static String getDataFormat(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return "";

    try {
      final newData = _parseDateWithArabicSupport(createdAt);
      return "${newData.day} ${getMonthName(newData.month)}, ${newData.year}";
    } catch (e) {
      debugPrint('Error in getDataFormat: $e');
      return "";
    }
  }

  static String formattedTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String convertTo12HourFormat(String time24) {
    try {
      final englishTime = _convertArabicNumbersToEnglish(time24);
      List<String> parts = englishTime.split(":");
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      String period = hour < 12 ? 'AM' : 'PM';
      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      debugPrint('Error in convertTo12HourFormat: $e');
      return "";
    }
  }

  static String getYYYMMDDFormatDate(String dateString) {
    try {
      final englishDateString = _convertArabicNumbersToEnglish(dateString);
      DateTime parsedDate = _parseDateWithArabicSupport(englishDateString);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      debugPrint('Error in getYYYMMDDFormatDate: $e');
      return getTodayDateInString();  
    }
  }

  static String getDayName(int day, [String locale = 'en']) {
    if (locale == 'ar') {
      switch (day) {
        case 1:
          return "الاثنين";
        case 2:
          return "الثلاثاء";
        case 3:
          return "الأربعاء";
        case 4:
          return "الخميس";
        case 5:
          return "الجمعة";
        case 6:
          return "السبت";
        case 7:
          return "الأحد";
        default:
          return "--";
      }
    } else {
      switch (day) {
        case 1:
          return "Monday";
        case 2:
          return "Tuesday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
        default:
          return "--";
      }
    }
  }

  static String getMonthName(int monthCode, [String locale = 'en']) {
    if (locale == 'ar') {
      switch (monthCode) {
        case 1:
          return "يناير";
        case 2:
          return "فبراير";
        case 3:
          return "مارس";
        case 4:
          return "أبريل";
        case 5:
          return "مايو";
        case 6:
          return "يونيو";
        case 7:
          return "يوليو";
        case 8:
          return "أغسطس";
        case 9:
          return "سبتمبر";
        case 10:
          return "أكتوبر";
        case 11:
          return "نوفمبر";
        case 12:
          return "ديسمبر";
        default:
          return "";
      }
    } else {
      switch (monthCode) {
        case 1:
          return "Jan";
        case 2:
          return "Feb";
        case 3:
          return "Mar";
        case 4:
          return "Apr";
        case 5:
          return "May";
        case 6:
          return "Jun";
        case 7:
          return "Jul";
        case 8:
          return "Aug";
        case 9:
          return "Sep";
        case 10:
          return "Oct";
        case 11:
          return "Nov";
        case 12:
          return "Dec";
        default:
          return "";
      }
    }
  }

  static String getTodayDateInString() {
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    } catch (e) {
      debugPrint('Error in getTodayDateInString: $e');
      return "";
    }
  }

  static String getTodayTimeInString() {
    try {
      return DateFormat('HH:mm').format(DateTime.now());
    } catch (e) {
      debugPrint('Error in getTodayTimeInString: $e');
      return "";
    }
  }

  static bool checkIfTimePassed(String time, String selectedDate) {
    if (selectedDate.isEmpty || time.isEmpty) return true;

    try {
      final englishDateString = _convertArabicNumbersToEnglish(selectedDate);
      DateTime parseSelectedDate = _parseDateWithArabicSupport(englishDateString);
      DateTime now = DateTime.now();

      DateTime selectedDateOnly = DateTime(parseSelectedDate.year,
          parseSelectedDate.month, parseSelectedDate.day);

      DateTime todayOnly = DateTime(now.year, now.month, now.day);
      int differenceInDays = selectedDateOnly.difference(todayOnly).inDays;

      if (differenceInDays == 0) {
        final englishTime = _convertArabicNumbersToEnglish(time);
        DateFormat format = DateFormat("HH:mm");
        DateTime inputTime = format.parse(englishTime);
        DateTime todayTime = DateTime(
            now.year, now.month, now.day, inputTime.hour, inputTime.minute);

        return todayTime.isBefore(now);
      }

      return differenceInDays < 0;
    } catch (e) {
      debugPrint('Error in checkIfTimePassed: $e');
      return true;
    }
  }
}
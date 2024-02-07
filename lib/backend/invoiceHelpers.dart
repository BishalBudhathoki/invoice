import 'package:intl/intl.dart';

class InvoiceHelpers {
  /// Finds the day of the week for a list of date strings.
  List<String> findDayOfWeek(List<String> dateList) {
    final daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return dateList.map((date) {
      final dayOfWeekIndex = DateTime.parse(date).weekday;
      return daysOfWeek[dayOfWeekIndex - 1];
    }).toList();
  }

  /// Gets the time period based on the provided time string.
  String getTimePeriod(String timeStr) {
    if (timeStr.isEmpty) return "Unknown";
    DateTime time = DateFormat.jm().parse(timeStr);
    int currentHour = time.hour;
    if (currentHour >= 6 && currentHour < 12) return "Morning";
    if (currentHour >= 12 && currentHour < 18) return "Daytime";
    if (currentHour >= 18 && currentHour < 21) return "Evening";
    return "Night";
  }

  /// Calculates total hours worked based on start and end times.
  List<double> calculateTotalHours(List<String> startTimeList, List<String> endTimeList, List<String> timeList) {
    List<double> totalHours = [];
    for (int i = 0; i < startTimeList.length; i++) {
      DateTime startTime = DateFormat.jm().parse(startTimeList[i]);
      DateTime endTime = DateFormat.jm().parse(endTimeList[i]);
      double hoursWorked = endTime.difference(startTime).inMinutes / 60.0; // Convert minutes to hours
      totalHours.add(hoursWorked);
    }
    return totalHours;
  }

  /// Gets the rate based on the day of the week and holidays.
  List<double> getRate(List<String> dayOfWeek, List<String> holidays) {
    List<double> rates = [];
    for (String day in dayOfWeek) {
      if (holidays.contains(day)) {
        rates.add(50.0); // Example rate for holidays
      } else if (day == 'Saturday' || day == 'Sunday') {
        rates.add(40.0); // Example rate for weekends
      } else {
        rates.add(30.0); // Example rate for weekdays
      }
    }
    return rates;
  }

  /// Gets the start and end dates of the week for a given date.
  List<DateTime> getWeekDates(DateTime date) {
    int weekday = date.weekday;
    DateTime startDate = date.subtract(Duration(days: weekday - 1));
    DateTime endDate = startDate.add(Duration(days: 6));
    return [startDate, endDate];
  }

// Add other helper functions as needed
}
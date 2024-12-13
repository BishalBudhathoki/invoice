import 'package:intl/intl.dart';

class InvoiceHelpers {

  Map<String, String> itemMap = {
    'Default': 'Item Map',
  };
  /// Finds the day of the week for a list of date strings.
  List<String> findDayOfWeek(List<String> dateList) {
    final daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
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
  List<double> calculateTotalHours(List<String> startTimeList,
      List<String> endTimeList, List<String> timeList) {
    List<double> totalHours = [];
    for (int i = 0; i < startTimeList.length; i++) {
      DateTime startTime = DateFormat.jm().parse(startTimeList[i]);
      DateTime endTime = DateFormat.jm().parse(endTimeList[i]);
      double hoursWorked = endTime.difference(startTime).inMinutes /
          60.0; // Convert minutes to hours
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
// List<String> findDayOfWeek(List<String> dateList) {
//     final daysOfWeek = [
//       'Sunday',
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday'
//     ];
//     return dateList.map((date) {
//       final dayOfWeekIndex = DateTime.parse(date).weekday;
//       return daysOfWeek[dayOfWeekIndex % 7];
//     }).toList();
//   }

  // List<double> getRate(List<String> dayOfWeek, List<String> holidays) {
  //   List<double> rates = [];
  //   for (int i = 0; i < dayOfWeek.length; i++) {
  //     String currentDayOfWeek = dayOfWeek[i];
  //     String currentHoliday = i < holidays.length ? holidays[i] : 'No Holiday';
  //     bool isHoliday = currentHoliday == 'Holiday';

  //     switch (currentDayOfWeek) {
  //       case 'Saturday':
  //       case 'Sunday':
  //         rates.add(isHoliday ? 110.0 : 55.0);
  //         break;
  //       default:
  //         rates.add(isHoliday ? 100.0 : 50.0);
  //     }
  //   }
  //   return rates;
  // }

  // List<double> calculateTotalHours(List<String> startTimeList,
  //     List<String> endTimeList, List<String> timeList) {
  //   List<double> hoursWorkedList = [];
  //   for (int i = 0; i < startTimeList.length; i++) {
  //     if (i < timeList.length) {
  //       hoursWorkedList.add(hoursFromTimeString(timeList[i]));
  //     } else {
  //       DateTime startTime = DateFormat('h:mm a').parse(startTimeList[i]);
  //       DateTime endTime = DateFormat('h:mm a').parse(endTimeList[i]);
  //       if (endTime.isBefore(startTime)) {
  //         endTime = endTime.add(const Duration(days: 1));
  //       }
  //       Duration duration = endTime.difference(startTime);
  //       hoursWorkedList.add(duration.inMinutes / 60);
  //     }
  //   }
  //   return hoursWorkedList;
  // }

  List<double> calculateTotalAmount(
      List<double> hours, List<double> rates, List<String> holidays) {
    List<double> totalAmount = [];
    for (int i = 0; i < hours.length; i++) {
      double amount = hours[i] * rates[i];
      if (i < holidays.length && holidays[i] != 'No Holiday') {
        amount *= 1.5; // Apply holiday rate
      }
      totalAmount.add(amount);
    }
    return totalAmount;
  }

  List<Map<String, dynamic>> getInvoiceComponent(
      List<String> workedDateList,
      List<String> startTimeList,
      List<String> endTimeList,
      List<String> holidays,
      List<String> timeList,
      String clientName) {
    List<Map<String, dynamic>> invoiceComponents = [];
    List<String> dayOfWeek = findDayOfWeek(workedDateList);
    List<String> timePeriods = getTimePeriods(startTimeList);

    for (int i = 0; i < workedDateList.length; i++) {
      String description =
          getComponentDescription(dayOfWeek[i], timePeriods[i], holidays[i]);
      double hoursWorked = hoursFromTimeString(timeList[i]);
      double assignedHour =
          hoursBetweenPerListItem(startTimeList[i], endTimeList[i]);

      invoiceComponents.add({
        'clientName': clientName,
        'date': workedDateList[i],
        'dayOfWeek': dayOfWeek[i],
        'startTime': startTimeList[i],
        'endTime': endTimeList[i],
        'hoursWorked': hoursWorked,
        'assignedHour': assignedHour,
        'holiday': holidays[i] == 'Holiday',
        'description': description,
      });
    }

    return invoiceComponents;
  }

  String getComponentDescription(
      String dayOfWeek, String timePeriod, String holiday) {
    bool isHoliday = holiday == 'Holiday';
    String key;

    if (isHoliday) {
      key = 'Public holiday';
    } else {
      switch (dayOfWeek) {
        case 'Saturday':
          key = 'Saturday';
          break;
        case 'Sunday':
          key = 'Sunday';
          break;
        default:
          switch (timePeriod) {
            case 'Evening':
              key = 'Weekday Evening';
              break;
            case 'Night':
              key = 'Night-Time Sleepover';
              break;
            default:
              key = 'Weekday Daytime';
          }
      }
    }

    return itemMap[key] ?? 'Unknown';
  }

  List<String> getTimePeriods(List<String> startTimeList) {
    return startTimeList.map((time) => getTimePeriod(time)).toList();
  }

  // String getTimePeriod(String timeStr) {
  //   DateTime time = DateFormat('h:mm a').parse(timeStr);
  //   int hour = time.hour;

  //   if (hour >= 6 && hour < 18) {
  //     return 'Daytime';
  //   } else if (hour >= 18 && hour < 22) {
  //     return 'Evening';
  //   } else {
  //     return 'Night';
  //   }
  // }

  double hoursFromTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2].split(' ')[0]);
    return hours + (minutes / 60) + (seconds / 3600);
  }

  double hoursBetweenPerListItem(String start, String end) {
    DateTime startTime = DateFormat('h:mm a').parse(start);
    DateTime endTime = DateFormat('h:mm a').parse(end);
    if (endTime.isBefore(startTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }
    return endTime.difference(startTime).inMinutes / 60;
  }

  // List<DateTime> getWeekDates(DateTime date) {
  //   int weekday = date.weekday;
  //   DateTime startDate = date.subtract(Duration(days: weekday - 1));
  //   DateTime endDate = startDate.add(const Duration(days: 6));
  //   return [startDate, endDate];
  // }
}

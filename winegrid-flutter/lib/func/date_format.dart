class DateReformat {

  static String reformat(String time) {

    if(time == null) {
      return "ONGOING";
    }

    String hours = DateTime.parse(time).toLocal().toString().substring(11,19);

    if(hours == '00:00:00') {
      hours = '';
    } else {
      hours = 'at $hours';
    }

    DateTime tm = DateTime.parse(time);
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);

    String month;
    switch (tm.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Today $hours";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday at $hours";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Monday $hours";
        case 2:
          return "Tuesday $hours";
        case 3:
          return "Wednesday $hours";
        case 4:
          return "Thurdsday $hours";
        case 5:
          return "Friday $hours";
        case 6:
          return "Saturday $hours";
        case 7:
          return "Sunday $hours";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month $hours';
    } else {
      return '${tm.day} $month ${tm.year} $hours';
    }
    return "";
  }

}
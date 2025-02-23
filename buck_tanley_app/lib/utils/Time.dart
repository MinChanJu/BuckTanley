class Time {
  /// 두 시간을 비교하는 함수
  ///
  /// time1: 첫 번째 시간
  ///
  /// time2: 두 번째 시간
  ///
  /// 두 시간이 같을 경우: 0
  ///
  /// 첫 번째 시간이 더 빠르고 날짜가 다른 경우: 1
  ///
  /// 첫 번째 시간이 더 빠르고 날짜가 같은 경우: 2
  ///
  /// 두 번째 시간이 더 빠르고 날짜가 다른 경우: 3
  ///
  /// 두 번째 시간이 더 빠르고 날짜가 같은 경우: 4
  static int compareTime(DateTime time1, DateTime time2) {
    if (time1.isBefore(time2)) {
      if (time1.year == time2.year && time1.month == time2.month && time1.day == time2.day) {
        return 2;
      } else {
        return 1;
      }
    } else if (time1.isAfter(time2)) {
      if (time1.year == time2.year && time1.month == time2.month && time1.day == time2.day) {
        return 4;
      } else {
        return 3;
      }
    } else {
      return 0;
    }
  }

  /// ex) 04:00
  static String getFormatTime(DateTime time) {
    String hour = time.toLocal().hour.toString().padLeft(2, '0');
    String minute = time.toLocal().minute.toString().padLeft(2, '0');
    String formatTime = "$hour:$minute";
    return formatTime;
  }

  /// ex) 2025/03/20
  static String getFormatDateS(DateTime time) {
    String year = time.toLocal().year.toString();
    String month = time.toLocal().month.toString().padLeft(2, '0');
    String day = time.toLocal().day.toString().padLeft(2, '0');
    String formatDay = "$year/$month/$day";
    return formatDay;
  }

  /// ex) 2025-03-20
  static String getFormatDateD(DateTime time) {
    String year = time.toLocal().year.toString();
    String month = time.toLocal().month.toString().padLeft(2, '0');
    String day = time.toLocal().day.toString().padLeft(2, '0');
    String formatDay = "$year-$month-$day";
    return formatDay;
  }

  /// 날짜가 같으면
  ///
  /// ex) 오후 12:20
  ///
  /// 날짜가 다르고 년도가 같으면
  ///
  /// ex) 3월 20일
  /// 
  /// 날짜가 다르고 년도도 다르면
  /// 
  /// ex) 2024-3-20
  static String getFormatDate(DateTime time) {
    DateTime now = DateTime.now().toLocal();
    DateTime local = time.toLocal();

    if (now.year == local.year && now.month == local.month && now.day == local.day) {
      int hourSub = local.hour;
      if (hourSub > 12) hourSub -= 12;
      String sun = local.hour >= 12 ? "오후" : "오전";
      String hour = hourSub.toString().padLeft(2, '0');
      String minute = local.minute.toString().padLeft(2, '0');
      return "$sun $hour:$minute";
    } else if (now.year == local.year) {
      String month = local.month.toString();
      String day = local.day.toString();
      return "$month월 $day일";
    } else {
      String year = (local.year%100).toString();
      String month = local.month.toString().padLeft(2, '0');
      String day = local.day.toString().padLeft(2, '0');
      return "$year-$month-$day";
    }
  }
}

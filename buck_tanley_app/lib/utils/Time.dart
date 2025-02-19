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

  static String getFormatTime(DateTime time) {
    String hour = time.toLocal().hour.toString().padLeft(2, '0');
    String minute = time.toLocal().minute.toString().padLeft(2, '0');
    String formatTime = "$hour:$minute";
    return formatTime;
  }

  static String getFormatDate(DateTime time) {
    String year = time.toLocal().year.toString();
    String month = time.toLocal().month.toString().padLeft(2, '0');
    String day = time.toLocal().day.toString().padLeft(2, '0');
    String formatDay = "$year/$month/$day";
    return formatDay;
  }
}
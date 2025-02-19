import 'package:buck_tanley_app/utils/Time.dart';

void main() {
  DateTime time1 = DateTime(1,2,3,5,5,6,7,8);
  DateTime time2 = DateTime(1,2,3,4,5,6,7,8);
  print(Time.compareTime(time1, time2));
}
import 'package:get_time_ago/get_time_ago.dart';

class CustomMessages implements Messages {
  @override
  String prefixAgo() => '';

  @override
  String suffixAgo() => 'ago';

  @override
  String secsAgo(int seconds) => '$seconds sec';

  @override
  String minAgo(int minutes) => 'a min';

  @override
  String minsAgo(int minutes) => '$minutes min';

  @override
  String hourAgo(int minutes) => 'an hr';

  @override
  String hoursAgo(int hours) => '$hours hrs';

  @override
  String dayAgo(int hours) => 'a day';

  @override
  String daysAgo(int days) => '$days days';

  @override
  String wordSeparator() => ' ';
}
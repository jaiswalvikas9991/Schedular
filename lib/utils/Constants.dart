import 'package:intl/intl.dart';

String dateTimeToString(DateTime dateTime) =>
    dateTime.toString().substring(0, 10);
String toDatabaseDateTimeString(DateTime date) =>
    DateFormat("yyyy-MM-dd HH:mm:ss").format(date);

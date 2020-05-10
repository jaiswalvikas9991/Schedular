import 'package:intl/intl.dart';

String dateTimeToString(DateTime dateTime) =>
    dateTime.toString().substring(0, 10);
String toDatabaseDateTimeString(DateTime date) =>
    DateFormat("yyyy-MM-dd HH:mm:ss").format(date);

String convert(dynamic value) => "_" + value.toString();

const String bucketKey = 'keys';
const String dateKey = 'last10';
const databaseName = 'data10';

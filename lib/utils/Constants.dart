import 'package:intl/intl.dart';

String dateTimeToString(DateTime dateTime) =>
    dateTime.toString().substring(0, 10);
String toDatabaseDateTimeString(DateTime date) =>
    DateFormat("yyyy-MM-dd HH:mm:ss").format(date);

String toTimeString(DateTime dateTime) => dateTime.toString().substring(11, 13);

String convert(dynamic value) => "_" + value.toString();

const String sub = 'substr(fromTime,12,2)';
const String baseCondition = 'bucket <> "" AND rating <> 0';

const String bucketKey = 'keys';
const String dateKey = 'last12';
const databaseName = 'data12';

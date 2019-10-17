import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final double width;
  final Color color;
  final Function onDayPressed;
  Calendar({this.width, this.color, @required this.onDayPressed});
  @override
  _CalendarState createState() => _CalendarState();
}

Widget customDayBuilder(
  bool isSelectable,
  int index,
  bool isSelectedDay,
  bool isToday,
  bool isPrevMonthDay,
  TextStyle textStyle,
  bool isNextMonthDay,
  bool isThisMonthDay,
  DateTime day,
) {
  if (day.day == 15) {
    return Center(
      child: Icon(Icons.local_airport),
    );
  } else {
    return null;
  }
}

class _CalendarState extends State<Calendar> {
  // DateTime _currentDate;
  bool isShrinked = false;
  CalendarController _calendarController = CalendarController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      decoration: new BoxDecoration(
        color: widget.color ?? Color(0xff0085FF),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: TableCalendar(
        calendarController: _calendarController,
        initialCalendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.week: 'Week',
        },
        calendarStyle: CalendarStyle(
          selectedColor: Colors.white,
          selectedStyle: TextStyle().copyWith(color: Colors.black),
          todayColor: Colors.grey[400],
          todayStyle: TextStyle().copyWith(color: Colors.black),
          holidayStyle: TextStyle().copyWith(color: Colors.white),
          weekendStyle: TextStyle().copyWith(color: Colors.white),
          outsideWeekendStyle: TextStyle().copyWith(color: Colors.white),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle().copyWith(color: Colors.white),
        ),
        headerStyle: HeaderStyle(
            leftChevronIcon: Icon(Icons.keyboard_arrow_left),
            rightChevronIcon: Icon(Icons.keyboard_arrow_right),
            formatButtonDecoration: BoxDecoration(
              color: Colors.transparent,
            )),
            onDaySelected: (DateTime date, _) => debugPrint(date.toString()),
            onUnavailableDaySelected: () => debugPrint("Go to next month"),
      ),
    );
  }
}

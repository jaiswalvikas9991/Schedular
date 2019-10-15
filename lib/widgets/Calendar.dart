import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class Calendar extends StatefulWidget {
  final double width;
  final Color color;
  Calendar({this.width,this.color});
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
  DateTime _currentDate;
  bool isShrinked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      decoration: new BoxDecoration(
        color: widget.color ??  Color(0xff0085FF),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CalendarCarousel<Event>(
            onDayPressed: (DateTime dateTime, List<dynamic> tempList) {},
            thisMonthDayBorderColor: Colors.grey,
            selectedDateTime: _currentDate,
            headerTitleTouchable: true,
            height: isShrinked
                ? MediaQuery.of(context).size.height * 0.23
                : MediaQuery.of(context).size.height * 0.50,
            //Selected date styles
            selectedDayButtonColor: const Color(0xffb6bfcf),
            selectedDayTextStyle: TextStyle(color: Colors.white),
            //header text styles
            headerTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            iconColor: Colors.white,
            //week days text styles
            weekdayTextStyle: TextStyle(color: Colors.white),
            //today text styles
            todayButtonColor: Colors.white,
            todayTextStyle: TextStyle(color: Colors.black),
            //all days text color
            daysTextStyle: TextStyle(color: Colors.white),
            //weekend days text color
            weekendTextStyle: TextStyle(color: Colors.white),
            weekFormat: isShrinked,
          ),
          Center(
            child: FlatButton(
              onPressed: () {
                setState(() {
                  isShrinked = !isShrinked;
                });
              },
              child: Icon(
                isShrinked ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

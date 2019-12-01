import 'package:flutter/material.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:intl/intl.dart';

class DayTray extends StatelessWidget {
  const DayTray({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoListBloc _todoListBloc = Provider.of<TodoListBloc>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Color(0xff3c9caa),Color(0xff779af8)])),
      width: MediaQuery.of(context).size.width * 0.90,
      child: StreamBuilder<DateTime>(
          stream: _todoListBloc.dateTimeObservable,
          initialData: DateTime.now(),
          builder: (context, snapshot) {
            return ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(DateFormat('EEEEE', 'en_US').format(snapshot.data)),
              subtitle: Text(DateFormat("yyyy-MM-dd").format(snapshot.data)),
              trailing: Text('Number'),
            );
          }),
    );
  }
}

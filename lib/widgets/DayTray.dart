import 'package:flutter/material.dart';

class DayTray extends StatelessWidget {
  const DayTray({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Card(
          child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Saturday'),
              subtitle: Text('Here comes the date'),
              trailing: Text('Number'),
            ),
        ),
      ),
    );
  }
}
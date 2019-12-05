// import 'package:flutter/material.dart';
// import 'package:schedular/bloc/TodoListBloc.dart';
// import 'package:schedular/utils/Provider.dart';
// import 'package:intl/intl.dart';
// import 'package:line_icons/line_icons.dart';

// class DayTray extends StatelessWidget {
//   const DayTray({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final TodoListBloc _todoListBloc = Provider.of<TodoListBloc>(context);
//     return Card(
//       elevation: 5,
//       child: StreamBuilder<DateTime>(
//           stream: _todoListBloc.dateTimeObservable,
//           initialData: DateTime.now(),
//           builder: (context, snapshot) {
//             return ListTile(
//               leading: Icon(
//                 LineIcons.calendar_check_o,
//                 color: Theme.of(context).primaryColor,
//               ),
//               title: Text(DateFormat('EEEEE', 'en_US').format(snapshot.data,),
//                   style: TextStyle(color: Theme.of(context).primaryColor)),
//               subtitle: Text(
//                 DateFormat("yyyy-MM-dd").format(snapshot.data),
//                 style: TextStyle(color: Theme.of(context).primaryColor),
//               ),
//               trailing: Text('Number' , style: TextStyle(color: Theme.of(context).primaryColor)),
//             );
//           }),
//     );
//   }
// }

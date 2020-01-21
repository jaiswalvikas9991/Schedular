import 'package:flutter/material.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:schedular/widgets/Calendar.dart';
import 'package:schedular/widgets/Todo.dart';
import 'package:schedular/bloc/PlanListBloc.dart';

class Home extends StatefulWidget {
  final Function changeCentralDate;
  Home(this.changeCentralDate, {Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  List<Widget> renderTodos(List<TodoBloc> allTodo) {
    List<Widget> todoWidgets = [];
    for (int i = 0; i < allTodo.length; i++) todoWidgets.add(Todo(allTodo[i]));
    return todoWidgets;
  }

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    final TodoListBloc _todoListBloc = Provider.of<TodoListBloc>(context);
    final PlanListBloc _planListBloc = Provider.of<PlanListBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Calendar(
                width: MediaQuery.of(context).size.width * 0.95,
                color: Theme.of(context).primaryColor,
                onDayPressed: (DateTime dateTime) {
                  bool isChanged = this.widget.changeCentralDate(
                      dateTime.toString().substring(0, 11).replaceAll(' ', ''));

                  if (isChanged) {
                    _planListBloc.clearALlPlan();
                    _planListBloc.initialRender(dateTime
                        .toString()
                        .substring(0, 11)
                        .replaceAll(' ', ''));
                  }
                }),
            Divider(
              color: Colors.black,
              indent: MediaQuery.of(context).size.width * 0.06,
              endIndent: MediaQuery.of(context).size.width * 0.06,
            ),
            StreamBuilder<List<TodoBloc>>(
                stream: _todoListBloc.allTodoObservable,
                builder: (context, AsyncSnapshot<List<TodoBloc>> snapshot) {
                  return snapshot.hasData
                      ? Expanded(
                          child: ListView(
                            children: this.renderTodos(snapshot.data),
                          ),
                        )
                      : Container();
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _todoListBloc.addTodo,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:schedular/widgets/Calendar.dart';
import 'package:schedular/widgets/Todo.dart';

class Home extends StatefulWidget {
  final String title;
  Home({Key key, this.title}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime dateTime; // This keeps track of which date was selected

  List<Widget> renderTodos(List<TodoBloc> allTodo) {
    List<Widget> todoWidgets = [];
    for (int i = 0; i < allTodo.length; i++) todoWidgets.add(Todo(allTodo[i]));
    return todoWidgets;
  }

  Widget build(BuildContext context) {
    final TodoListBloc _todoListBloc = Provider.of<TodoListBloc>(context);
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
              onDayPressed: (DateTime dateTime) => this.dateTime = dateTime,
            ),
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

  @override
  void dispose() {
    super.dispose();
  }
}

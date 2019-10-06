import 'package:flutter/material.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/widgets/Calendar.dart';
import 'package:schedular/widgets/Todo.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TodoListBloc _todoListBloc = new TodoListBloc();

  List<Widget> renderTodos(List<Map<String, dynamic>> todos) {
    List<Widget> todoWidgets = [];
    for (int i = 0; i < todos.length; i++)
      todoWidgets.add(Todo(todos[i]['id'], this._todoListBloc));
    return todoWidgets;
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Calendar(
              width: MediaQuery.of(context).size.width * 0.95,
            ),
            Divider(
              color: Colors.black,
              indent: 20,
              endIndent: 20,
            ),
            StreamBuilder(
                stream: _todoListBloc.allTodoObservable,
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _todoListBloc.addTodo,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

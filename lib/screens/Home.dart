import 'package:flutter/material.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:schedular/bloc/TodoListBloc.dart';
import 'package:schedular/utils/Animate.dart';
import 'package:schedular/utils/Provider.dart';
import 'package:schedular/utils/constants.dart';
import 'package:schedular/widgets/Calendar.dart';
import 'package:schedular/widgets/PlaceHolder.dart';
import 'package:schedular/widgets/Todo.dart';
import 'package:schedular/bloc/PlanListBloc.dart';

class Home extends StatefulWidget {
  final Function changeCentralDate;
  Home(this.changeCentralDate, {Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  bool isChanged =
                      this.widget.changeCentralDate(dateTimeToString(dateTime));

                  if (isChanged) {
                    _planListBloc.clearALlPlan();
                    _planListBloc.initialRender(dateTimeToString(dateTime));
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
                  return snapshot.hasData && snapshot.data.length != 0
                      ? Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Animator(
                                      duration: 200,
                                      child: Todo(snapshot.data[index]))),
                        )
                      : Expanded(
                          child: Center(
                              child: PlaceHolder(
                                  fontSize: 20.0,
                                  data: "This is the Notes \n Taking Area")));
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _todoListBloc.addTodo,
        tooltip: "Add a new Todo",
      ),
    );
  }
}

import 'package:rxdart/rxdart.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:uuid/uuid.dart';


class TodoListBloc {
  static final Uuid id = Uuid();
  List<TodoBloc> _allTodo = [];

  BehaviorSubject<List<TodoBloc>> _subjectAllTodo;

  TodoListBloc()
      : _subjectAllTodo =
            new BehaviorSubject<List<TodoBloc>>.seeded([]);

  Observable<List<TodoBloc>> get allTodoObservable =>
      _subjectAllTodo.stream;

  void addTodo() {
    this._allTodo.add(new TodoBloc(id.v1()));
    _subjectAllTodo.sink.add(this._allTodo);
  }

  void deleteTodo(String id) {
    this._allTodo.removeAt(this._allTodo.indexOf(_getTodoById(id)));
    _subjectAllTodo.sink.add(this._allTodo);
  }

  // This is a helper function
  TodoBloc _getTodoById(String id) {
    for (int i = 0; i < this._allTodo.length; i++)
      if (this._allTodo[i].id == id) return this._allTodo[i];
    return null;
  }

  void dispose() {
    _subjectAllTodo.close();
  }
}

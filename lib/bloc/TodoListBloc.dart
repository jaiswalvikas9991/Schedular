import 'package:rxdart/rxdart.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:uuid/uuid.dart';
import 'package:schedular/utils/DBProvider.dart';

class TodoListBloc {
  static final Uuid id = Uuid();
  List<TodoBloc> _allTodo = [];

  TodoListBloc() {
    DBProvider.db.getAllTodo().then((value) {
      this._allTodo = value;
      if (this._allTodo.length != 0)
        this._subjectAllTodo.sink.add(this._allTodo);
    }); // This gets the data on startup of the
  }

  BehaviorSubject<List<TodoBloc>> _subjectAllTodo =
      new BehaviorSubject<List<TodoBloc>>();

  Observable<List<TodoBloc>> get allTodoObservable => _subjectAllTodo.stream;
  void addTodo() {
    TodoBloc newTodo = new TodoBloc(id.v1());
    this._allTodo.add(newTodo); // This adds the todo to the cache
    this._subjectAllTodo.sink.add(this._allTodo);
    DBProvider.db.addTodo(newTodo); // this add's the todo in the database
  }

  void deleteTodo(String id) {
    TodoBloc deleteTodo = this._getTodoById(id);
    this._allTodo.removeAt(this._allTodo.indexOf(deleteTodo));
    _subjectAllTodo.sink.add(this._allTodo);
    DBProvider.db.deleteTodo(id);
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

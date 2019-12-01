import 'package:rxdart/rxdart.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:uuid/uuid.dart';

class TodoListBloc {
  static final Uuid id = Uuid();
  List<TodoBloc> _allTodo = [];
  List<Map<String, dynamic>> _allTodoData = [];
  DateTime _selectedDate;

  BehaviorSubject<List<TodoBloc>> _subjectAllTodo;
  BehaviorSubject<DateTime> _subjectDateTime;

  TodoListBloc() {
    _subjectAllTodo = new BehaviorSubject<List<TodoBloc>>();
    _subjectDateTime = new BehaviorSubject<DateTime>();
    _selectedDate = DateTime.now();
  }

  Observable<List<TodoBloc>> get allTodoObservable => _subjectAllTodo.stream;
  Observable<DateTime> get dateTimeObservable => _subjectDateTime.stream;


  void setDate(DateTime date){
    this._selectedDate = date;
    _subjectDateTime.add(this._selectedDate);
  }

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

  Map<String, dynamic> _getTodoDataById(String id){
    for (int i = 0; i < this._allTodoData.length; i++) if (this._allTodoData[i]['id'] == id) return this._allTodoData[i];
    return {};
  } 

  

  void upDateData(String id, String childKey, dynamic newValue){
    Map<String, dynamic> _updateTodo = _getTodoDataById(id);

    switch(childKey){
      case 'content' : _updateTodo['content'] = newValue;break;
      case 'isChecked' : _updateTodo['isChecked'] = newValue;break;
    }

  }

  void dispose() {
    _subjectAllTodo.close();
  }
}

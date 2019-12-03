import 'package:rxdart/rxdart.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:uuid/uuid.dart';
import 'package:schedular/utils/DBProvider.dart';

class TodoListBloc {
  static final Uuid id = Uuid();
  List<TodoBloc> _allTodo = [];
  DateTime _selectedDate = DateTime.now();

  TodoListBloc(){
    DBProvider.db.getAllTodo().then((value){
      this._allTodo = value;
      if(this._allTodo.length != 0) this._subjectAllTodo.sink.add(this._allTodo);
    }); // This gets the data on startup of the
  }

  BehaviorSubject<List<TodoBloc>> _subjectAllTodo = new BehaviorSubject<List<TodoBloc>>();
  BehaviorSubject<DateTime> _subjectDateTime = new BehaviorSubject<DateTime>();


  Observable<List<TodoBloc>> get allTodoObservable => _subjectAllTodo.stream;
  Observable<DateTime> get dateTimeObservable => _subjectDateTime.stream;


  // Experimental central date time store
  void setDate(DateTime date){
    this._selectedDate = date;
    _subjectDateTime.add(this._selectedDate);
  }

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

  // This is a helper function
  // Map<String, dynamic> _getTodoDataById(String id){
  //   for (int i = 0; i < this._allTodoData.length; i++) if (this._allTodoData[i]['id'] == id) return this._allTodoData[i];
  //   return {};
  // } 

  
  // This method just updates the main data not the stream
  // void upDateData(String id, String childKey, dynamic newValue){
  //   Map<String, dynamic> _updateTodo = _getTodoDataById(id);

  //   switch(childKey){
  //     case 'content' : _updateTodo['content'] = newValue;break;
  //     case 'isChecked' : _updateTodo['isChecked'] = newValue;break;
  //   }

  // }

  void dispose() {
    _subjectAllTodo.close();
  }
}

import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class TodoListBloc {
    List<Map<String, dynamic>> _allTodoData = [];
    static Uuid randomId = Uuid();

  BehaviorSubject<List<Map<String,dynamic>>> _subjectAllTodo;

  TodoListBloc(){
    _subjectAllTodo = new BehaviorSubject<List<Map<String,dynamic>>>.seeded([]);
  }

  Observable<List<Map<String,dynamic>>> get allTodoObservable => _subjectAllTodo.stream;

  
  void addTodo(){
    this._allTodoData.add({ 'id' : randomId.v1(), 'content' : '', 'isChecked' : false});
    _subjectAllTodo.sink.add(this._allTodoData);
  }

  void deleteTodo(String id){
    this._allTodoData.removeAt(this._allTodoData.indexOf(_getTodoById(id)));
    _subjectAllTodo.sink.add(this._allTodoData);
  }

  void updateTodoContent(String content, String id){
    if(_getTodoById(id)['content'] == content) _getTodoById(id)['content'] = content;
  }

  void updateTodoIsChecked(bool isChecked, String id){
    _getTodoById(id)['isChecked'] = isChecked;
  }

  Map<String, dynamic> _getTodoById(String id){
    for(int i = 0; i < this._allTodoData.length ; i++) if(this._allTodoData[i]['id'] == id) return this._allTodoData[i];
    return {};
  }

  void dispose() {
    _subjectAllTodo.close();
  }
}
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class PlanListBloc{
  static final randomId = Uuid();
  List<Map<String, dynamic>> _allPlanData = [];

  BehaviorSubject<List<Map<String,dynamic>>> _subjectAllPlan;

  PlanListBloc(){
    _subjectAllPlan = new BehaviorSubject<List<Map<String,dynamic>>>.seeded([]);
  }

  Observable<List<Map<String,dynamic>>> get allPlanObservable => _subjectAllPlan.stream;

  void addTodo(){
    this._allPlanData.add({ 'id' : randomId.v1(), 'content' : '', 'isChecked' : false});
    _subjectAllPlan.sink.add(this._allPlanData);
  }

  void deleteTodo(String id){
    this._allPlanData.removeAt(this._allPlanData.indexOf(_getTodoById(id)));
    _subjectAllPlan.sink.add(this._allPlanData);
  }

  void updateTodoContent(String content, String id){
    if(this._getTodoById(id)['content'] == content) this._getTodoById(id)['content'] = content;
  }

  void updateTodoIsChecked(bool isChecked, String id){
    this._getTodoById(id)['isChecked'] = isChecked;
  }

  Map<String, dynamic> _getTodoById(String id){
    for(int i = 0; i < this._allPlanData.length ; i++) if(this._allPlanData[i]['id'] == id) return this._allPlanData[i];
    return {};
  }

   void dispose() {
    _subjectAllPlan.close();
  }
}
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:schedular/bloc/PlanBloc.dart';

class PlanListBloc{
  static final randomId = Uuid();
  List<PlanBloc> _allPlan = [];

  BehaviorSubject<List<PlanBloc>> _subjectAllPlan;

  PlanListBloc(){
    _subjectAllPlan = new BehaviorSubject<List<PlanBloc>>();
  }

  Observable<List<PlanBloc>> get allPlanObservable => _subjectAllPlan.stream;

  void addPlan(){
    this._allPlan.add(PlanBloc(randomId.v1()));
    _subjectAllPlan.sink.add(this._allPlan);
  }

  void deletePlan(String id){
    this._allPlan.removeAt(this._allPlan.indexOf(_getPlanById(id)));
    _subjectAllPlan.sink.add(this._allPlan);
  }

  // Helper Method
  PlanBloc _getPlanById(String id){
    for(int i = 0; i < this._allPlan.length ; i++) if(this._allPlan[i].id == id) return this._allPlan[i];
    return null;
  }

   void dispose() {
    _subjectAllPlan.close();
  }
}
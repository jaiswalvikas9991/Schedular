import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/utils/DBProvider.dart';

class PlanListBloc {
  static final randomId = Uuid();
  List<PlanBloc> _allPlan = [];

  PlanListBloc() {
    this.initialRender(
        DateTime.now().toString().substring(0, 11).replaceAll(' ', ''));
  }

  BehaviorSubject<List<PlanBloc>> _subjectAllPlan =
      new BehaviorSubject<List<PlanBloc>>();

  Observable<List<PlanBloc>> get allPlanObservable => _subjectAllPlan.stream;

  void addPlan(String date) {
    PlanBloc newPlan = new PlanBloc(randomId.v1(), date: date);
    this._allPlan.add(newPlan);
    _subjectAllPlan.sink.add(this._allPlan);
    DBProvider.db.addPlan(newPlan);
  }

  void deletePlan(String id) async {
    this._allPlan.removeAt(this._allPlan.indexOf(_getPlanById(id)));
    _subjectAllPlan.sink.add(this._allPlan);
    // FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    //     new FlutterLocalNotificationsPlugin();
    // await _flutterLocalNotificationsPlugin.cancel(id.hashCode);
    DBProvider.db.deletePlan(id);
  }

  // Helper Method
  PlanBloc _getPlanById(String id) {
    for (int i = 0; i < this._allPlan.length; i++)
      if (this._allPlan[i].id == id) return this._allPlan[i];
    return null;
  }

  void initialRender(String date) {
    DBProvider.db.getPlanByDate(date).then((value) {
      this._allPlan = value;
      if (this._allPlan.length != 0)
        this._subjectAllPlan.sink.add(this._allPlan);
    });
  }

  void clearALlPlan() => this._allPlan.clear();

  void dispose() {
    _subjectAllPlan.close();
  }
}

import 'package:rxdart/rxdart.dart';

class PlanBloc {
  // Real Date
  String id;
  bool _isChecked;
  int _rating;
  String _description;
  DateTime _fromTime;
  DateTime _toTime;
  bool _isNotification;
  bool _isAlarm;

  // Behaviour Subject

  BehaviorSubject<bool> _subjectIsChecked = new  BehaviorSubject<bool>();
  BehaviorSubject<int> _subjectRating = new BehaviorSubject<int>();
  BehaviorSubject<String> _subjectDescription = new BehaviorSubject<String>();
  BehaviorSubject<DateTime> _subjectFromTime = new  BehaviorSubject<DateTime>();
  BehaviorSubject<DateTime> _subjectToTime = BehaviorSubject<DateTime>();
  BehaviorSubject<bool> _subjectIsNotification = BehaviorSubject<bool>();
  BehaviorSubject<bool> _subjectIsAlarm = new   BehaviorSubject<bool>();

  PlanBloc(this.id);

  // Stream
  Observable<bool> get isCheckedObservable => this._subjectIsChecked.stream;
  Observable<int> get ratingObservable => this._subjectRating.stream;
  Observable<String> get descriptionObservable =>
      this._subjectDescription.stream;
  Observable<DateTime> get fromTimeObservable => this._subjectFromTime.stream;
  Observable<DateTime> get toTimeObservable => this._subjectToTime.stream;
  Observable<bool> get isNotificationObservable =>
      this._subjectIsNotification.stream;
  Observable<bool> get isAlarmObservable => this._subjectIsAlarm.stream;

  void updateCheckedState(bool isChecked) {
    this._isChecked = isChecked;
    _subjectIsChecked.sink.add(this._isChecked);
  }

  void updateRating(int rating) {
    this._rating = rating;
    _subjectRating.sink.add(this._rating);
  }

  void updateDescription(String description) {
    this._description = description;
    _subjectDescription.sink.add(this._description);
  }

  void dispose() {
    _subjectIsChecked.close();
    _subjectRating.close();
    _subjectDescription.close();
    _subjectFromTime.close();
    _subjectToTime.close();
    _subjectIsNotification.close();
    _subjectIsAlarm.close();
  }
}

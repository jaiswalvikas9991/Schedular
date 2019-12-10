import 'package:rxdart/rxdart.dart';
import 'package:schedular/utils/DBProvider.dart';

class PlanBloc {
  // Real Date
  String id;
  bool _isChecked = false;
  int _rating = 0;
  String _description = '';
  DateTime _fromTime = DateTime.now();
  DateTime _toTime = DateTime.now();
  bool _isNotification = false;
  String _date = DateTime.now().toString().substring(0, 11).replaceAll(' ', '');
  // bool _isAlarm;

  // Behaviour Subject

  BehaviorSubject<bool> _subjectIsChecked = new BehaviorSubject<bool>();
  BehaviorSubject<int> _subjectRating = new BehaviorSubject<int>();
  BehaviorSubject<String> _subjectDescription = new BehaviorSubject<String>();
  BehaviorSubject<DateTime> _subjectFromTime = new BehaviorSubject<DateTime>();
  BehaviorSubject<DateTime> _subjectToTime = BehaviorSubject<DateTime>();
  BehaviorSubject<bool> _subjectIsNotification = BehaviorSubject<bool>();
  // BehaviorSubject<bool> _subjectIsAlarm = new   BehaviorSubject<bool>();

  PlanBloc(this.id,
      {isChecked,
      rating,
      description,
      fromTime,
      toTime,
      isNotification,
      date}) {
    this._isChecked = isChecked ?? false;
    this._rating = rating ?? 0;
    this._description = description ?? "";
    this._fromTime = fromTime ?? DateTime.now();
    this._toTime = toTime ?? DateTime.now();
    this._isNotification = isNotification ?? false;
    this._date =
        date ?? DateTime.now().toString().substring(0, 11).replaceAll(' ', '');

    _subjectIsChecked.sink.add(this._isChecked);
    _subjectRating.sink.add(this._rating);
    _subjectDescription.sink.add(this._description == '' ? "Describe this awsome task to me......" : this._description);
    _subjectFromTime.sink.add(this._fromTime);
    _subjectToTime.sink.add(this._toTime);
    _subjectIsNotification.sink.add(this._isNotification);
  }

  // This constructor is used when the data is fetched from the database
  factory PlanBloc.fromMap(Map<String, dynamic> planBloc) {
    return PlanBloc(planBloc["id"],
        isChecked: planBloc["isChecked"] == 1,
        rating: planBloc["rating"],
        description: planBloc["description"],
        fromTime: DateTime.parse(planBloc["fromTime"]),
        toTime: DateTime.parse(planBloc["toTime"]),
        isNotification: planBloc["isNotification"] == 1,
        date: planBloc["date"]);
  }

  // Stream
  Observable<bool> get isCheckedObservable => this._subjectIsChecked.stream;
  Observable<int> get ratingObservable => this._subjectRating.stream;
  Observable<String> get descriptionObservable =>
      this._subjectDescription.stream;
  Observable<DateTime> get fromTimeObservable => this._subjectFromTime.stream;
  Observable<DateTime> get toTimeObservable => this._subjectToTime.stream;
  Observable<bool> get isNotificationObservable =>
      this._subjectIsNotification.stream;
  // Observable<bool> get isAlarmObservable => this._subjectIsAlarm.stream;

  void updateCheckedState() {
    this._isChecked = !this._isChecked;
    _subjectIsChecked.sink.add(this._isChecked);
    DBProvider.db.updatePlan(this.toMap());
  }

  void updateRating(int rating) {
    if (this._rating != rating) {
      this._rating = rating;
      _subjectRating.sink.add(this._rating);
      DBProvider.db.updatePlan(this.toMap());
    }
  }

  void updateDescription(String description) {
    if (this._description != description) {
      this._description = description;
      _subjectDescription.sink.add(this._description);
      DBProvider.db.updatePlan(this.toMap());
    }
  }

  void updateToTime(DateTime time) {
    if (this._toTime != time) {
      this._toTime = time;
      this._subjectToTime.sink.add(this._toTime);
      DBProvider.db.updatePlan(this.toMap());
    }
  }

  void updateFromTime(DateTime time) {
    if (this._fromTime != time) {
      this._fromTime = time;
      this._subjectFromTime.sink.add(this._fromTime);
      DBProvider.db.updatePlan(this.toMap());
    }
  }

  void updateNotificationState() {
    this._isNotification = !this._isNotification;
    _subjectIsNotification.sink.add(this._isNotification);
    DBProvider.db.updatePlan(this.toMap());
  }

  void dispose() {
    _subjectIsChecked.close();
    _subjectRating.close();
    _subjectDescription.close();
    _subjectFromTime.close();
    _subjectToTime.close();
    _subjectIsNotification.close();
    // _subjectIsAlarm.close();
  }

  Map<String, dynamic> toMap() => {
        "id": this.id,
        "description": this._description,
        "rating": this._rating,
        "fromTime": this._fromTime.toString(),
        "toTime": this._toTime.toString(),
        "isChecked": this._isChecked ? 1 : 0,
        "isNotification": this._isNotification ? 1 : 0,
        "date": this._date
      };


    DateTime getFromTime() => this._fromTime;
    int getRating() => this._rating;
}

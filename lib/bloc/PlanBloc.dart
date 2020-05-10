import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:schedular/utils/DBProvider.dart';
import 'package:schedular/utils/Constants.dart';

class PlanBloc {
  // Real Date
  String id;
  bool _isChecked = false;
  int _rating = 0;
  String _description = '';
  DateTime _fromTime = DateTime.now();
  DateTime _toTime = DateTime.now().add(new Duration(minutes: 45));
  bool _isNotification = false;
  DateTime _date = DateTime.now();
  String _bucket = "";
  // bool _isAlarm;

  // Behaviour Subject
  BehaviorSubject<bool> _subjectIsChecked = new BehaviorSubject<bool>();
  BehaviorSubject<int> _subjectRating = new BehaviorSubject<int>();
  BehaviorSubject<String> _subjectDescription = new BehaviorSubject<String>();
  BehaviorSubject<DateTime> _subjectFromTime = new BehaviorSubject<DateTime>();
  BehaviorSubject<DateTime> _subjectToTime = BehaviorSubject<DateTime>();
  BehaviorSubject<bool> _subjectIsNotification = BehaviorSubject<bool>();
  BehaviorSubject<String> _subjectBucket = BehaviorSubject<String>();
  // BehaviorSubject<bool> _subjectIsAlarm = new   BehaviorSubject<bool>();

  PlanBloc(this.id,
      {bool isChecked,
      int rating,
      String description,
      DateTime fromTime,
      DateTime toTime,
      bool isNotification,
      DateTime date,
      bucket}) {
    this._isChecked = isChecked ?? this._isChecked;
    this._rating = rating ?? this._rating;
    this._description = description ?? this._description;
    this._fromTime = fromTime ?? this._fromTime;
    this._toTime = toTime ?? this._toTime;
    this._isNotification = isNotification ?? this._isNotification;
    this._date = date ?? DateTime.now();
    this._bucket = bucket ?? "";

    _subjectIsChecked.sink.add(this._isChecked);
    _subjectRating.sink.add(this._rating);
    _subjectDescription.sink.add(this._description);
    _subjectFromTime.sink.add(this._fromTime);
    _subjectToTime.sink.add(this._toTime);
    _subjectIsNotification.sink.add(this._isNotification);
    _subjectBucket.sink.add(this._bucket);
  }

  //* This constructor is used when the data is fetched from the database
  factory PlanBloc.fromMap(Map<String, dynamic> planBloc) {
    return PlanBloc(planBloc["id"],
        isChecked: planBloc["isChecked"] == 1,
        rating: planBloc["rating"],
        description: planBloc["description"],
        fromTime: DateTime.parse(planBloc["fromTime"]),
        toTime: DateTime.parse(planBloc["toTime"]),
        isNotification: planBloc["isNotification"] == 1,
        date: DateTime.parse(planBloc["date"]),
        bucket: planBloc["bucket"]);
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
  Observable<String> get bucketObservable => this._subjectBucket.stream;
  // Observable<bool> get isAlarmObservable => this._subjectIsAlarm.stream;

  void updateBucketState(String bucket) {
    if (this._bucket == bucket) return;
    this._bucket = bucket;
    _subjectBucket.sink.add(this._bucket);
    DBProvider.db.updatePlan(this.toMap());
  }

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

  void updateFromTime(DateTime time) async {
    if (this._fromTime != time) {
      this._fromTime = time;
      // This is to respond to the time changes when the notifications are on
      if (this._isNotification) {
        //! UnComment this to enabel notification
        FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
            new FlutterLocalNotificationsPlugin();
        await _flutterLocalNotificationsPlugin.cancel(this.id.hashCode);
        this._setNotification();
        //! Comment ends hear
      }
      this._subjectFromTime.sink.add(this._fromTime);
      DBProvider.db.updatePlan(this.toMap());
    }
  }

  Future<void> _setNotification() async {
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();

    var scheduledNotificationDateTime = this._fromTime;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.schedule(
        this.id.hashCode,
        this._bucket,
        this._description,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> updateNotificationState() async {
    this._isNotification = !this._isNotification;

    //! UnCommenty this to enabel notification
    if (_isNotification) {
      await this._setNotification();
    } else {
      FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
          new FlutterLocalNotificationsPlugin();
      await _flutterLocalNotificationsPlugin.cancel(this.id.hashCode);
    }
    //! Comment ends hear
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
    _subjectBucket.close();
  }

  Map<String, dynamic> toMap() => {
        "id": this.id,
        "description": this._description,
        "rating": this._rating,
        "fromTime": toDatabaseDateTimeString(this._fromTime),
        "toTime": toDatabaseDateTimeString(this._toTime),
        "isChecked": this._isChecked ? 1 : 0,
        "isNotification": this._isNotification ? 1 : 0,
        "date": toDatabaseDateTimeString(this._date),
        "bucket": this._bucket
      };

  DateTime getFromTime() => this._fromTime;
  int getRating() => this._rating;
}

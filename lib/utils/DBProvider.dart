import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:schedular/utils/Constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//* This is a singleton class
class DBProvider {
  DBProvider._();
  // This is the instance of the class
  static final DBProvider db = DBProvider._();

  // This is the instance to the sql lite database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      //* This is the table for the todos
      await db.execute("CREATE TABLE todo ("
          "id TEXT PRIMARY KEY,"
          "content TEXT,"
          "isChecked BIT"
          ")");

      //* This is the table for the plans
      await db.execute("CREATE TABLE plan ("
          "id TEXT PRIMARY KEY,"
          "description TEXT,"
          "rating INTEGER,"
          "date TEXT,"
          "fromTime TEXT,"
          "toTime TEXT,"
          "isNotification BIT,"
          "isChecked BIT,"
          "bucket TEXT"
          ")");

      //* This is table for the frequencies of the rating
      await db.execute("CREATE TABLE bucket ("
          "bucket TEXT,"
          "rating1 INTEGER,"
          "rating2 INTEGER,"
          "rating3 INTEGER,"
          "rating4 INTEGER,"
          "rating5 INTEGER,"
          "total INTEGER"
          ")");

      //* This is the table for the frequencies of the time
      await db.execute("CREATE TABLE time ("
          "time TEXT,"
          "rating1 INTEGER,"
          "rating2 INTEGER,"
          "rating3 INTEGER,"
          "rating4 INTEGER,"
          "rating5 INTEGER,"
          "total INTEGER"
          ")");

      await db.execute("CREATE TABLE bucketTime ("
          "bucket TEXT,"
          "_00 INTEGER,"
          "_01 INTEGER,"
          "_02 INTEGER,"
          "_03 INTEGER,"
          "_04 INTEGER,"
          "_05 INTEGER,"
          "_06 INTEGER,"
          "_07 INTEGER,"
          "_08 INTEGER,"
          "_09 INTEGER,"
          "_10 INTEGER,"
          "_11 INTEGER,"
          "_12 INTEGER,"
          "_13 INTEGER,"
          "_14 INTEGER,"
          "_15 INTEGER,"
          "_16 INTEGER,"
          "_17 INTEGER,"
          "_18 INTEGER,"
          "_19 INTEGER,"
          "_20 INTEGER,"
          "_21 INTEGER,"
          "_22 INTEGER,"
          "_23 INTEGER,"
          "total INTEGER"
          ")");

      await db.execute("CREATE TABLE ratingTime ("
          "time TEXT,"
          "_1 INTEGER,"
          "_2 INTEGER,"
          "_3 INTEGER,"
          "_4 INTEGER,"
          "_5 INTEGER,"
          "total INTEGER"
          ")");
    });
  }

  // To add a todo
  addTodo(TodoBloc todoBloc) async {
    final db = await database;
    var res = await db.insert("todo", todoBloc.toMap());
    return res;
  }

  // To get a single todo : This will return a new TodoBloc with filled in data fields
  getTodoById(String id) async {
    final db = await database;
    var res = await db.query("todo", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? TodoBloc.fromMap(res.first) : [];
  }

  // To get all todo's for the database : returns the list of all TodoBlocs with filled in data fields
  getAllTodo() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM todo");
    List<TodoBloc> result = [];
    for (int i = 0; i < res.length; i++) {
      result.add(TodoBloc.fromMap(res[i]));
    }
    List<TodoBloc> list = res.isNotEmpty ? result : [];
    return list;
  }

  // To update a todo
  updateTodo(Map<String, dynamic> todo) async {
    final db = await database;
    var res =
        await db.update("todo", todo, where: "id = ?", whereArgs: [todo["id"]]);
    return res;
  }

  deleteTodo(String id) async {
    final db = await database;
    db.delete("todo", where: "id = ?", whereArgs: [id]);
  }

  addPlan(PlanBloc planBloc) async {
    final db = await database;
    var res = await db.insert("plan", planBloc.toMap());
    return res;
  }

  getPlanByDate(DateTime date) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM plan WHERE date(date) = date(?)',
        [toDatabaseDateTimeString(date)]);
    print(res.toString());
    List<PlanBloc> result = [];
    for (int i = 0; i < res.length; i++) {
      result.add(PlanBloc.fromMap(res[i]));
    }
    return result;
  }

  updatePlan(Map<String, dynamic> plan) async {
    //print(plan.toString());
    final db = await database;
    var res =
        await db.update("plan", plan, where: "id = ?", whereArgs: [plan["id"]]);
    return res;
  }

  deletePlan(String id) async {
    final db = await database;
    db.delete("plan", where: "id = ?", whereArgs: [id]);
  }

  getPlanWeek(DateTime date) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM plan WHERE date(date) > date(?, "-7 day")',
        [toDatabaseDateTimeString(date)]);
    List<PlanBloc> result = [];
    for (int i = 0; i < res.length; i++) {
      result.add(PlanBloc.fromMap(res[i]));
    }
    //print("This is result : " + result.toString());
    return (result);
  }

  getPlanMonth(DateTime date) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM plan WHERE date(date) > date(?, "-30 day")',
        [toDatabaseDateTimeString(date)]);
    List<PlanBloc> result = [];
    for (int i = 0; i < res.length; i++) {
      result.add(PlanBloc.fromMap(res[i]));
    }
    return (result);
  }

  Future<String> copyDb() async {
    final Directory databasePath = await getApplicationDocumentsDirectory();
    final sourcePath = join(databasePath.path, 'data.db');
    final db = await database;
    db.close();
    _database = null;
    return (sourcePath);
  }

  //# This is the start of the Machine Learning Methods
  Future<List<Map<String, dynamic>>> getMlData(DateTime date) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
        'SELECT rating, fromTime, bucket FROM plan WHERE date(date) >= date(?)',
        [toDatabaseDateTimeString(date)]);

    List<Map<String, dynamic>> result = [];
    res.forEach((Map<String, dynamic> value) {
      if (value['rating'] != 0 && value['bucket'] != '') {
        Map<String, dynamic> map = new Map<String, dynamic>.from(value);
        map['fromTime'] = map['fromTime'].split(' ')[1].substring(0, 2);
        map['bucket'] = map['bucket'].toLowerCase();
        result.add(map);
      }
    });
    //print(result);
    return (result);
  }

  Future<double> getBucketProbabilityFromRating(
      int rating, String bucket) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery('SELECT * FROM bucket WHERE bucket = ?', [bucket]);
    if (res == null || res.length == 0) return (1 / 5);
    return ((res[0]['rating' + rating.toString()] + 1) / (res[0]['total']) + 5);
  }

  Future<double> getTimeProbabilityFromRating(int rating, String time) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery('SELECT * FROM time WHERE time = ?', [time]);
    if (res == null || res.length == 0) return (1 / 5);
    return ((res[0]['rating' + rating.toString()] + 1) / (res[0]['total'] + 5));
  }

  Future<double> getPrior(int rating) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
        'SELECT SUM(?) as sum_rating, SUM(total) as sum_total FROM time',
        ['rating' + rating.toString()]);
    if (res == null || res.length == 0) return (1 / 5);
    return ((res[0]['sum_rating'] + 1) / (res[0]['sum_total'] + 5));
  }

  _insertBucketTable(String bucket) async {
    final db = await database;
    await db.insert("bucket", {
      'bucket': bucket,
      'rating1': 0,
      'rating2': 0,
      'rating3': 0,
      'rating4': 0,
      'rating5': 0,
      'total': 0
    });
    return (true);
  }

  _insertTimeTable(String time) async {
    final db = await database;
    await db.insert("time", {
      'time': time,
      'rating1': 0,
      'rating2': 0,
      'rating3': 0,
      'rating4': 0,
      'rating5': 0,
      'total': 0
    });
    return (true);
  }

  updateBucketTable(int rating, String bucket) async {
    final db = await database;
    List<Map<String, dynamic>> old =
        await db.query("bucket", where: "bucket = ?", whereArgs: [bucket]);

    //* This is called only once in the lifetime
    if (old == null || old.length == 0) {
      await _insertBucketTable(bucket);
      old = await db.query("bucket", where: "bucket = ?", whereArgs: [bucket]);
    }

    Map<String, dynamic> map = new Map<String, dynamic>.from(old[0]);
    map['rating' + rating.toString()]++;
    map['total']++;
    var res = await db
        .update("bucket", map, where: "bucket = ?", whereArgs: [bucket]);
    return res;
  }

  updateTimeTable(int rating, String time) async {
    final db = await database;
    List<Map<String, dynamic>> old =
        await db.query("time", where: "time = ?", whereArgs: [time]);

    if (old == null || old.length == 0) {
      await _insertTimeTable(time);
      old = await db.query("time", where: "time = ?", whereArgs: [time]);
    }
    Map<String, dynamic> map = new Map<String, dynamic>.from(old[0]);
    map['rating' + rating.toString()]++;
    map['total']++;
    var res =
        await db.update("time", map, where: "time = ?", whereArgs: [time]);
    return res;
  }

  Future<void> checkData(String table) async {
    final db = await database;
    print(await db.rawQuery('SELECT * FROM $table'));
  }

  //# This is the start of the methods for the time based Naive Bayes
  //* This is the probability of seeing a time - P(time = 9)
  Future<double> getTimeProb(String time) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
        'SELECT SUM(${convert(time)}) as num, SUM(total) as den FROM bucketTime');
    if (res == null || res.isEmpty) return (0.0);
    return ((res[0]['num'] + 1.0) / (res[0]['den'] + 24.0));
  }

  //* P(bucket = 'coding' | time = 9)
  Future<double> getBucketTimeProb(String bucket, String time) async {
    final db = await database;
    List<Map<String, dynamic>> nume = await db.rawQuery(
        'SELECT ${convert(time)} as nume FROM bucketTime WHERE bucket = ?',
        [bucket]);

    List<Map<String, dynamic>> deno = await db
        .rawQuery('SELECT SUM(?) as deno FROM bucketTime', [convert(time)]);
    if (nume == null || nume.isEmpty || deno == null || deno.isEmpty)
      return (0.0);
    return ((nume[0]['nume'] + 1.0) / (deno[0]['deno'] + 24.0));
  }

  //* P(rating = 5 | time = 9)
  Future<double> getRatingTimeProb(int rating, String time) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db
        .rawQuery('SELECT * FROM ratingTime WHERE time = ?', [convert(time)]);
    if (res == null || res.isEmpty) return (0.0);
    int nume = res[0][convert(rating)];
    int deno = res[0][convert(1)] +
        res[0][convert(2)] +
        res[0][convert(3)] +
        res[0][convert(4)] +
        res[0][convert(5)];
    return ((nume + 1.0) / (deno + 24.0));
  }

  Future<bool> updateRatingTime(int rating, String time) async {
    final db = await database;
    List<Map<String, dynamic>> old = await db
        .rawQuery('SELECT * FROM ratingTime WHERE time = ?', [convert(time)]);
    if (old == null || old.isEmpty)
      return (await _insertRatingTime(rating, time));
    Map<String, dynamic> map = Map.from(old[0]);
    map[convert(rating)]++;
    map['total']++;
    await db.update('ratingTime', map,
        where: 'time = ?', whereArgs: [convert(time)]);
    return (true);
  }

  Future<bool> updateBucketTime(String bucket, String time) async {
    final db = await database;
    List<Map<String, dynamic>> old = await db
        .rawQuery('SELECT * FROM bucketTime WHERE bucket = ?', [bucket]);
    if (old == null || old.isEmpty)
      return (await _insertBucketTime(bucket, time));
    Map<String, dynamic> map = Map.from(old[0]);
    map[convert(time)]++;
    map['total']++;
    await db
        .update('bucketTime', map, where: 'bucket = ?', whereArgs: [bucket]);
    return (true);
  }

  Future<bool> _insertRatingTime(int rating, String time) async {
    final db = await database;
    Map<String, dynamic> map = {
      'time': convert(time),
      convert(1): 0,
      convert(2): 0,
      convert(3): 0,
      convert(4): 0,
      convert(5): 0,
      'total': 1
    };
    map[convert(rating)] = 1;
    await db.insert('ratingTime', map);
    return (true);
  }

  Future<bool> _insertBucketTime(String bucket, String time) async {
    final db = await database;
    Map<String, dynamic> map = {
      'bucket': bucket,
      convert("00"): 0,
      convert("01"): 0,
      convert("02"): 0,
      convert("03"): 0,
      convert("04"): 0,
      convert("05"): 0,
      convert("06"): 0,
      convert("07"): 0,
      convert("08"): 0,
      convert("09"): 0,
      convert("10"): 0,
      convert("11"): 0,
      convert("12"): 0,
      convert("13"): 0,
      convert("14"): 0,
      convert("15"): 0,
      convert("16"): 0,
      convert("17"): 0,
      convert("18"): 0,
      convert("19"): 0,
      convert("20"): 0,
      convert("21"): 0,
      convert("22"): 0,
      convert("23"): 0,
      'total': 1
    };
    map[convert(time)] = 1;
    await db.insert('bucketTime', map);
    return (true);
  }

  void dispose() async {
    final db = await database;
    db.close();
    _database = null;
  }
}

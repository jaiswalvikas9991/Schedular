import 'dart:collection';
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
    String path = join(documentsDirectory.path, "data.db");
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
          "1 INTEGER,"
          "2 INTEGER,"
          "3 INTEGER,"
          "4 INTEGER,"
          "5 INTEGER,"
          "total INTEGER"
          ")");

      //* This is the table for the frequencies of the time
      await db.execute("CREATE TABLE time ("
          "time TEXT,"
          "1 INTEGER,"
          "2 INTEGER,"
          "3 INTEGER,"
          "4 INTEGER,"
          "5 INTEGER,"
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

  // List<String> _getWeekListFromDate(String date) {
  //   List<String> list = new List<String>();
  //   for (int i = 0; i <= 7; i++)
  //     list.add(dateTimeToString(DateTime.now().subtract(Duration(days: i))));
  //   //print(list);
  //   return (list);
  // }

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

  // List<String> _getMonthListFromDate(String date) {
  //   List<String> list = new List<String>();
  //   for (int i = 0; i <= 30; i++)
  //     list.add(dateTimeToString(DateTime.now().subtract(Duration(days: i))));
  //   return (list);
  // }

  getPlanMonth(DateTime date) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM plan WHERE date(date) > date(?, "-30 day")',
        [toDatabaseDateTimeString(date)]);
    List<PlanBloc> result = [];
    for (int i = 0; i < res.length; i++) {
      result.add(PlanBloc.fromMap(res[i]));
    }
    updateRatingTable(String bucket, String rating) async {
      final db = await database;
      List<Map<String, dynamic>> old = await db.query("rating",
          where: "bucket = ? AND rating = ?",
          whereArgs: [bucket, rating.toString()]);
      old[0][rating.toString()]++;
      old[0]['total']++;
      var res = await db.update("rating", old[0],
          where: "bucket = ? AND rating = ?", whereArgs: [bucket, rating]);
      return res;
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
    for (int i = 0; i < res.length; i++) {
      if (res[i]['rating'] == 0) continue;
      //* This gets the hour from the day from the date time
      res[i]['fromTime'] = res[i]['fromTime'].subString(0, 2);
      result.add(res[i]);
    }
    return (result);
  }

  Future<double> getBucketProbabilityFromRating(
      int rating, String bucket) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery('SELECT * FROM bucket WHERE bucket = ?', [bucket]);
    if (res == null || res.length == 0) return (1 / 5);
    return ((res[0][rating.toString()] + 1) / (res[0]['total']) + 5);
  }

  Future<double> getTimeProbabilityFromRating(int rating, String time) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.rawQuery('SELECT * FROM time WHERE time = ?', [time]);
    if (res == null || res.length == 0) return (1 / 5);
    return ((res[0][time] + 1) / (res[0]['total'] + 5));
  }

  Future<double> getPrior(int rating) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.rawQuery(
        'SELECT SUM(?) as sum_rating, SUM(total) as sum_total FROM time',
        [rating.toString()]);
    if (res == null || res.length == 0) return (1 / 5);
    return ((res[0]['sum_ratin'] + 1) / (res[0]['sum_total'] + 5));
  }

  // Future<int> getTotalRatingForBucket(String bucket) async {
  //   final db = await database;
  //   List<Map<String, dynamic>> res = await db
  //       .rawQuery('SELECT total FROM rating WHERE bucket = ?', [bucket]);
  //   if (res[0]['total'] == null) return (0);
  //   return (res[0]['total']);
  // }

  // Future<int> getTotalTimeForBucket(String bucket) async {
  //   final db = await database;
  //   List<Map<String, dynamic>> res =
  //       await db.rawQuery('SELECT total FROM time WHERE bucket = ?', [bucket]);
  //   if (res[0]['total'] == null) return (0);
  //   return (res[0]['total']);
  // }

  _insertBucketTable(String bucket) async {
    final db = await database;
    await db.insert("bucket",
        {'bucket': bucket, '1': 0, '2': 0, '3': 0, '4': 0, '5': 0, 'total': 0});
    return (true);
  }

  _insertTimeTable(String time) async {
    final db = await database;
    await db.insert("time",
        {'time': time, '1': 0, '2': 0, '3': 0, '4': 0, '5': 0, 'total': 0});
    return (true);
  }

  updateBucketTable(int rating, String bucket) async {
    final db = await database;
    List<Map<String, dynamic>> old =
        await db.query("bucket", where: "bucket = ?", whereArgs: [bucket]);

    if (old == null || old.length == 0) {
      await _insertBucketTable(bucket);
      old = await db.query("bucket", where: "bucket = ?", whereArgs: [bucket]);
    }
    old[0][rating.toString()]++;
    old[0]['total']++;
    var res = await db
        .update("rating", old[0], where: "bucket = ?", whereArgs: [bucket]);
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
    old[0][time]++;
    old[0]['total']++;
    var res =
        await db.update("time", old[0], where: "time = ?", whereArgs: [time]);
    return res;
  }

  void dispose() async {
    final db = await database;
    db.close();
    _database = null;
  }
}

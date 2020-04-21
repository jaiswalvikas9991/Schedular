import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:schedular/bloc/PlanBloc.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:schedular/utils/constants.dart';
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
      await db.execute("CREATE TABLE todo ("
          "id TEXT PRIMARY KEY,"
          "content TEXT,"
          "isChecked BIT"
          ")");
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

  getPlanByDate(String date) async {
    final db = await database;
    var res = await db.query("plan", where: "date = ?", whereArgs: [date]);
    List<PlanBloc> result = [];
    for (int i = 0; i < res.length; i++) {
      result.add(PlanBloc.fromMap(res[i]));
    }
    List<PlanBloc> list = res.isNotEmpty ? result : [];
    return list;
  }

  updatePlan(Map<String, dynamic> plan) async {
    final db = await database;
    var res =
        await db.update("plan", plan, where: "id = ?", whereArgs: [plan["id"]]);
    return res;
  }

  deletePlan(String id) async {
    final db = await database;
    db.delete("plan", where: "id = ?", whereArgs: [id]);
  }

  List<String> _getWeekListFromDate(String date) {
    List<String> list = new List<String>();
    for (int i = 0; i <= 7; i++)
      list.add(dateTimeToString(DateTime.now().subtract(Duration(days: i))));
      //print(list);
    return (list);
  }

  getPlanWeek(String date) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM plan WHERE date IN (?, ?, ?, ?, ?, ?, ?, ?)', this._getWeekListFromDate(date));
    List<PlanBloc> result = [];
    for (int i = 0; i < res.length; i++) {
      result.add(PlanBloc.fromMap(res[i]));
    }
    List<PlanBloc> list = res.isNotEmpty ? result : [];
    //print("This is result : " + result.toString());
    return list;
  }

  List<String> _getMonthListFromDate(String date) {
    List<String> list = new List<String>();
    for (int i = 0; i <= 30; i++)
      list.add(dateTimeToString(DateTime.now().subtract(Duration(days: i))));
    return (list);
  }

  getPlanMonth(String date) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM plan WHERE date IN (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', this._getMonthListFromDate(date));
    List<PlanBloc> result = [];
    for (int i = 0; i < res.length; i++) {
      result.add(PlanBloc.fromMap(res[i]));
    }
    List<PlanBloc> list = res.isNotEmpty ? result : [];
    return list;
  }

  Future<String> copyDb() async {
    final Directory databasePath = await getApplicationDocumentsDirectory();
    final sourcePath = join(databasePath.path, 'data.db');
    final db = await database;
    db.close();
    _database = null;
    return (sourcePath);
  }

  void dispose() async {
    final db = await database;
    db.close();
    _database = null;
  }
}

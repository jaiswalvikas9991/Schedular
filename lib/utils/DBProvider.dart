import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:schedular/bloc/TodoBloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "test2.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE todo ("
          "id TEXT PRIMARY KEY,"
          "content TEXT,"
          "isChecked BIT"
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
    debugPrint(res.toString());
    for(int i = 0 ; i < res.length ; i++){
      result.add(TodoBloc.fromMap(res[i]));
    }
    List<TodoBloc> list =
        res.isNotEmpty ? result : [];
    return list;
  }

  // To update a todo
  updateTodo(Map<String, dynamic> todo) async {
    final db = await database;
    debugPrint(todo.toString());
    var res = await db.update("todo", todo,
        where: "id = ?", whereArgs: [todo["id"]]);
    return res;
  }

  deleteTodo(String id) async {
    final db = await database;
    db.delete("todo", where: "id = ?", whereArgs: [id]);
  }
}

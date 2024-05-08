// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_exam/task_entity.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, completed INTEGER)');
  }

  Future<int> insertTask(TaskEntity task) async {
    var dbClient = await db;
    int res = await dbClient.insert('tasks', task.toMap());
    return res;
  }

  Future<List<TaskEntity>> getTasks() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient.query('tasks');
    List<TaskEntity> tasks = [];
    for (int i = 0; i < list.length; i++) {
      tasks.add(TaskEntity.fromMap(list[i]));
    }
    return tasks;
  }

  Future<int> updateTask(TaskEntity task) async {
    var dbClient = await db;
    return await dbClient
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    return await dbClient.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}

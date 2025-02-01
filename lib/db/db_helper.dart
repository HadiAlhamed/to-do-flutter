import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/models/task.dart';

class DbHelper {
  static const String _tableName = "tasks";
  static const int _version = 1;
  static Database? _db;
  static Future<void> init() async {
    if (_db != null) return;
    try {
      String path = '${await getDatabasesPath()}tasks.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE $_tableName( '
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING , note TEXT , isCompleted INTEGER, '
            'date STRING, '
            'startTime STRING , endTime STRING, '
            'color INTEGER, '
            'remind INTEGER , repeat STRING '
            ')',
          );
        },
      );

      log('dataBase created');
    } catch (err) {
      log("${err}could not create the database");
    }
  }

  static Future<int> insert(Task task) async {
    try {
      return await _db!.insert(_tableName, task.toJson());
    } catch (err) {
      log("${err}insert problem");
      return 1;
    }
  }

  static Future<int> delete(Task task) async {
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> update(int taskId, int? isCompleted) async {
    return await _db!.rawUpdate(
      '''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
      ''',
      [isCompleted ?? 1, taskId],
    );
  }

  static Future<void> deleteAll() async {
    await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    log("query function");
    return _db!.query(_tableName);
  }
}

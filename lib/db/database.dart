import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tp_mod_11/model/users.dart';

class UsersDb {
  static final UsersDb instance = UsersDb._internal();

  static Database? _database;

  UsersDb._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDb();
    return _database!;
  }

  Future<Database> openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
    );

    return database;
  }

  Future<Users> insertUsers(Users model) async {
    final db = await instance.database;
    final id = await db.insert('users', model.toJson());
    log(id.toString());
    return model;
  }

  Future<List<Users>> getUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    log(result.toString());
    return result.map((json) => Users.fromJson(json)).toList();
  }

  Future<int> updateUsers(Users model) async {
    final db = await instance.database;
    return db.update(
      'users',
      model.toJson(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> deleteUsers(int id) async {
    final db = await instance.database;
    return db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String columnId = "_id";
final String columnName = "name";
final String columnDone = "done";

class Todo {
  int id;
  String name;
  bool done;

  Todo({this.id, this.name, this.done});

  factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
        id: json[columnId],
        name: json[columnName],
        done: json[columnDone] == 1,
      );

  Map<String, dynamic> toMap() => {
        columnName: name,
        columnDone: done == false ? 0 : 1,
      };
}

class TodoProvider {
  static final TodoProvider db = TodoProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await openDB("todo.db");
      return _database;
    }
  }

  Future openDB(String path) async {
    return await openDatabase(path, version: 1,
        onCreate: (Database _database, int version) async {
      await _database.execute(
          '''create table $tableTodo ($columnId integer primary key autoincrement, $columnName text not null,$columnDone integer not null)''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    final _database = await database;
    todo.id = await _database.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<List<Todo>> getDone() async {
    final _database = await database;
    var result = await _database.query(tableTodo, where: "done = 1");

    List<Todo> list =
        result.isNotEmpty ? result.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Todo>> getNotDone() async {
    final _database = await database;
    var result = await _database.query(tableTodo, where: "done = 0");

    List<Todo> list =
        result.isNotEmpty ? result.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<void> swapper(Todo todo) async {
    final db = await database;
    Todo done = Todo(id: todo.id, name: todo.name, done: !todo.done);
    var result = await db.update(tableTodo, done.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
    return result;
  }

  Future<void> deleteDone() async {
    final _database = await database;
    return await _database.delete(tableTodo, where: '$columnDone = 1');
  }

  Future close() async => _database.close();
}

//import 'dart:js_interop';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/group.dart';
import '../models/todo.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static const String databaseName = "database.sqlite";
  static Database? db;

  static Future<Database> initializeDb() async {
    final databasePath = (await getApplicationDocumentsDirectory()).path;
    final path = join(databasePath, databaseName);
    print(path);
    return db ??
        await openDatabase(path, version: 2,
            onCreate: (Database db, int version) async {
          await createTables(db);
        }, onUpgrade: (db, oldVersion, newVersion) async {
          await updateTables(db, oldVersion, newVersion);
        });
          
  }


  static updateTables(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion)
    {
      if (oldVersion < 2) // add group table with link on todo 
      {
        db.execute("""
              CREATE TABLE Groups(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL
              )      
            """);
        db.execute("""ALTER TABLE Todos ADD COLUNM group_FK INTEGER """);
      }
    }
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE Todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        completed INT
      )      
    """);
  }

  static Future<int> createItem(Todo todo) async {
    final db = await DatabaseService.initializeDb();

    final id = await db.insert('Todos',
        Todo(content: todo.content, completed: todo.completed).toMap());
    return id;
  }

  static Future<List<Todo>> getItems() async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, Object?>> queryResult = await db.query('Todos');
    return queryResult.map((e) => Todo.fromMap(e)).toList() as List<Todo>;
  }


  static Future<Todo> getItem(int id) async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, Object?>> queryResult =
        await db.query('Todos', where: "id = $id");

    print("BBBBBBBBB");
    print(queryResult[0]);
    print("AAAAAAAA");

    return Todo(
      id: queryResult[0]["id"] as int,
      content: queryResult[0]["content"] as String,
      completed: queryResult[0]["completed"] as int == 1,
    );
  }

  static Future<Todo> getItemFromGroup(int groupId) async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, Object?>> queryResult =
        await db.query('Todos', where: "group_FK = $groupId");


    return Todo(
      id: queryResult[0]["id"] as int,
      content: queryResult[0]["content"] as String,
      completed: queryResult[0]["completed"] as int == 1,
    );
  }

  static Future<bool> updateTaskStatue(int id, bool isCompleted) async {
    final db = await DatabaseService.initializeDb();

    await db.update("Todos", {"completed": !isCompleted ? 1 : 0},
        where: 'id = $id');

    return true;
  }

  static Future<List<Group>> getGroups() async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, Object?>> queryResult = await db.query('Groups');
    return queryResult.map((e) => Group.fromMap(e)).toList();
  }

  static Future<Group> getGroup(int id) async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, Object?>> queryResult =
        await db.query('Groups', where: "id = $id");


    return Group(
      id: queryResult[0]["id"] as int,
      name: queryResult[0]["name"] as String,
    );
  }

  static Future<int> createGroup(Group group) async {
    final db = await DatabaseService.initializeDb();
print("Create group : "+group.name);
    final id = await db.insert('Groups',
        Group(name: group.name).toMap());
print ("Create group ID : "+id.toString());
    return id;
  }
  


}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class DatabaseService {
  static const String databaseName = "database.sqlite";
  static Database? db;

  static Future<Database> initializeDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return db ??
        await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
          await createTables(db);
        });
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

  static Future<bool> updateTaskStatue(int id, bool isCompleted) async {
    final db = await DatabaseService.initializeDb();

    await db.update("Todos", {"completed": !isCompleted ? 1 : 0},
        where: 'id = $id');

    return true;
  }
}

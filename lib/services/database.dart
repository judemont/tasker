//import 'dart:js_interop';


import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/group.dart';
import '../models/todo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt ;
import 'dart:convert' as convert;


class DatabaseService {
  static const String databaseName = "database.sqlite";
  static Database? db;

  static const DATABASE_VERSION = 6;
  List<String> tables =[
   
  ];

  static const SECRET_KEY = "2021_PRIVATE_KEY_ENCRYPT_2021";

  static Future<Database> initializeDb() async {
    final databasePath = (await getApplicationDocumentsDirectory()).path;
    final path = join(databasePath, databaseName);
    print(path);
    return db ??
        await openDatabase(
          path,
          version: DATABASE_VERSION,
          onCreate: (Database db, int version) async {
            await createTables(db);
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            await updateTables(db, oldVersion, newVersion);
          },
          onOpen: (db) async {
            await openDB(db);
          },
        );
  }

  static openDB(Database db) {
    //db.execute("UPDATE Todo SET groupId = 0 WHERE groupId IS NULL");
    db.execute(
        "UPDATE Todos SET groupId = 1 WHERE groupId is null OR groupId = 0 ");
    /*
    print("** rename table **"); 
        
        
        

    db.execute("""
      CREATE TABLE Todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        completed INT,
        groupId INT
      )      
    """);
*/

    print("** show tables **");
    db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;').then((value) {
      print(value);
    });
  }

  static updateTables(Database db, int oldVersion, int newVersion) {
    print(" DB Version : $newVersion");
    db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;').then((value) {
      print(value);
    });


    if (oldVersion < newVersion) {
      if (oldVersion < 2) // add group table with link on todo
      {
        db.execute("""
              CREATE TABLE Groups(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL
              )      
            """);
        db.execute("""ALTER TABLE Todos ADD COLUMN group_FK INT """);
      }

      if (oldVersion < 3) // add default group and rename group_fk
      {
        db.execute("ALTER TABLE Todos RENAME COLUMN group_FK TO groupId ");
/*
        db.insert("group", Group(name:"Default group").toMap()).then((value) {
          db.execute("UPDATE Todo SET groupId = "+value.toString()+" WHERE groupId IS NULL");
        });
*/
      }

      if (oldVersion < 4) // add description
      {
        db.execute("""ALTER TABLE Todos ADD COLUMN description TEXT """);
      }

      if (oldVersion < 5) // new Tables
      {
        db.execute("DROP TABLE Todos");
        db.execute("DROP TABLE Groups");
        db.execute("""
              CREATE TABLE Groups(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL
              )      
            """);

        db.execute("""
            CREATE TABLE Todos(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              content TEXT NOT NULL,
              completed INT,
              description TEXT,
              groupId INT
            ) 
            """);
      }

      if (oldVersion < 6) {
        db.insert('Groups', Group(name: "Default").toMap());
      }
    }
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE Todos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          content TEXT NOT NULL,
          completed INT,
          description TEXT,
          groupId INT
      )      
    """);

    await database.execute("""
    CREATE TABLE Groups(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    )          
    """);

    await database.insert('Groups', Group(name: "Default").toMap());

  }

  static Future<int> createItem(Todo todo) async {
    final db = await DatabaseService.initializeDb();

    final id = await db.insert(
        'Todos',
        Todo(
                content: todo.content,
                completed: todo.completed,
                description: todo.description,
                groupId: todo.groupId)
            .toMap());
    return id;
  }

  static Future<List<Todo>> getItems() async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, Object?>> queryResult = await db.query('Todos');
    return queryResult.map((e) => Todo.fromMap(e)).toList();
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

  static Future<List<Todo>> getItemFromGroup(int groupId) async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, Object?>> queryResult =
        await db.query('Todos', where: "groupId = $groupId");
    return queryResult.map((e) => Todo.fromMap(e)).toList();
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
    print("Create group : ${group.name}");
    final id = await db.insert('Groups', Group(name: group.name).toMap());
    print("Create group ID : $id");
    return id;
  }

  static Future<void> removeTask(int taskId) async {
    final db = await DatabaseService.initializeDb();
    db.delete("Todos", where: "id = $taskId");
  }

  static Future<void> removeGroup(int groupId) async {
    final db = await DatabaseService.initializeDb();
    db.delete("Groups", where: "id = $groupId");
  }

  static Future<void> removeTasksFromGroup(int groupId) async {
    final db = await DatabaseService.initializeDb();
    db.delete("Todos", where: "groupId = $groupId");
  }

  static Future<void> updateTask(Todo todo) async {
    final db = await DatabaseService.initializeDb();
    db.update("Todos", todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }



    Future<String>generateBackup({bool isEncrypted = false}) async {

    print('GENERATE BACKUP');
   
    var dbs = await DatabaseService.initializeDb();

    List data =[];

    List<Map<String,dynamic>> listMaps=[];

    for (var i = 0; i < tables.length; i++)
    {

      listMaps = await dbs.query(tables[i]); 

      data.add(listMaps);

    }

    List backups=[tables,data];

    String json = convert.jsonEncode(backups);

    if(isEncrypted)
    {

      var key = encrypt.Key.fromUtf8(SECRET_KEY);
      var iv = encrypt.IV.fromLength(16);
      var encrypter = encrypt.Encrypter(encrypt.AES(key));
      var encrypted = encrypter.encrypt(json, iv: iv);
        
      return encrypted.base64;  
    }
    else
    {
      return json;
    }
  }

  Future<void>restoreBackup(String backup,{ bool isEncrypted = false}) async {

    var dbs = await DatabaseService.initializeDb();
    
    Batch batch = dbs.batch();
    
    var key = encrypt.Key.fromUtf8(SECRET_KEY);
    var iv = encrypt.IV.fromLength(16);
    var encrypter = encrypt.Encrypter(encrypt.AES(key));

    List json = convert.jsonDecode(isEncrypted ? encrypter.decrypt64(backup,iv:iv):backup);

    for (var i = 0; i < json[0].length; i++)
    {
      for (var k = 0; k < json[1][i].length; k++)
      {
        batch.insert(json[0][i],json[1][i][k]);
      }
    }

    await batch.commit(continueOnError:false,noResult:true);

    print('RESTORE BACKUP');
  }

}


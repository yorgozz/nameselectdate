import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'userinfo.dart';

class UserDatabase {
  static final UserDatabase instance =
      UserDatabase._init(); //making sure bass wehde database crearted
  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    //create database and if existed do nthg
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    //creation and open db and if not exist create one
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    //creation of db
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        dateOfBirth TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertUser(UserInfo user) async {
    //insert user in db (userInfo-->DB)
    // final db = await instance.database;
    await _database!.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm
            .replace); //hayde ta eza id already mawjud i replace with new
  }

  Future<List<UserInfo>> getUsers() async {
    //bchouf kell users bel db w b7oton bi a list of UserInfo
    final db = await instance.database;
    final maps = await db.query('users');
    return List.generate(maps.length, (index) => UserInfo.fromMap(maps[index]));
  }

  Future<void> deleteUser(String userId) async {
    //deletion of user using id
    final db = await instance.database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }
}

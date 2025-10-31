import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:projet/models/User.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  late Database _database;

  DatabaseHelper._();
  static DatabaseHelper get instance {
    if (_instance == null) {
      _instance = DatabaseHelper._();
    }
    return _instance!;
  }

  DatabaseHelper();

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'food_app.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT,
            password TEXT,
            isAdmin INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    if (_database == null) {
      throw Exception('Database not initialized. Call initDatabase() first.');
    }

    await _database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByEmail(String email) async {
    if (_database == null) {
      throw Exception('Database not initialized. Call initDatabase() first.');
    }

    final List<Map<String, dynamic>> maps = await _database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        username: maps[0]['username'],
        email: maps[0]['email'],
        password: maps[0]['password'],
        isAdmin: maps[0]['isAdmin'] == 1,
      );
    } else {
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    if (_database == null) {
      throw Exception('Database not initialized. Call initDatabase() first.');
    }

    final List<Map<String, dynamic>> maps = await _database.query('users');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        email: maps[i]['email'],
        password: maps[i]['password'],
        isAdmin: maps[i]['isAdmin'] == 1,
      );
    });
  }
}
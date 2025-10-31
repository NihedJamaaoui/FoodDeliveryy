import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:projet/models/food.dart';

class FoodDataProvider extends ChangeNotifier {
  late final Database _database;
  List<Food> _foods = [];
  List<Food> _filteredFoods = [];
  bool _isLoading = false;

  List<Food> get foods => _filteredFoods;
  bool get isLoading => _isLoading;

  FoodDataProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await initDB();
  }

  static Future<Database> initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'foood_app.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE foods (
            id INTEGER PRIMARY KEY,
            name TEXT,
            image TEXT,
            time TEXT,
            ratting TEXT
          )
        ''');
      },
    );
  }

  Future<List<Food>> fetchFoods() async {
    _isLoading = true;
    notifyListeners();
    try {
      final Database db = await initDB();
      final List<Map<String, dynamic>> maps = await db.query('foods');
      _foods = List.generate(maps.length, (i) {
        return Food.fromMap(maps[i]);
      });
      _filteredFoods = _foods;
      return _foods;
    } catch (e) {
      print('Error fetching foods: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Food getFoodById(int id) {
    return _foods.firstWhere((food) => food.id == id);
  }

  Future<void> addFood(Food food) async {
    _isLoading = true;
    notifyListeners();
    try {
      final Database db = await initDB();
      await db.insert('foods', food.toMap());
      _foods = await fetchFoods();
      notifyListeners();
    } catch (e) {
      print('Error adding food: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editFood(Food food) async {
    _isLoading = true;
    notifyListeners();
    try {
      int index = _foods.indexWhere((p) => p.id == food.id);
      if (index != -1) {
        final Database db = await initDB();
        await db.update('foods', food.toMap(),
            where: 'id = ?', whereArgs: [food.id]);
        _foods = await fetchFoods(); // Update the list after editing a food
      }
    } catch (e) {
      print('Error editing food: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFood(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final Database db = await initDB();
      await db.delete('foods', where: 'id = ?', whereArgs: [id]);
      _foods = await fetchFoods();
    } catch (e) {
      print('Error deleting food: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Food> get filteredFoods => _filteredFoods;

  void filterFoods(String query) {
    _filteredFoods = _foods
        .where((food) =>
        food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}

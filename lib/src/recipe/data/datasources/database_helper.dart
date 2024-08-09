import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recipe_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE recipes(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            imageUrl TEXT,
            ingredients TEXT,
            instructions TEXT,
            cuisine TEXT,
            dishType TEXT,
            preparationMethod TEXT,
            spiceLevel TEXT,
            servingSize TEXT,
            mealTypes TEXT,
            rating REAL,
            ratingCount INTEGER,
            feedback TEXT,
            isFavorite INTEGER
          )
        ''');
      },
    );
  }
}

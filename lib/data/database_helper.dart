// lib/data/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'ecommerce.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderNumber TEXT NOT NULL,
        date TEXT NOT NULL,
        fullName TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL,
        items TEXT NOT NULL,
        total REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL DEFAULT '',
        email TEXT NOT NULL DEFAULT '',
        phone TEXT NOT NULL DEFAULT '',
        darkMode INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('cart_items');
    await db.delete('orders');
    await db.delete('user_profile');
  }
}

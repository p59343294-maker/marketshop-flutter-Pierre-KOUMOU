// lib/data/repositories/order_repository.dart

import '../database_helper.dart';
import '../models/order.dart';

class OrderRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<Order>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('orders', orderBy: 'date DESC');
    return maps.map(Order.fromMap).toList();
  }

  Future<Order?> getById(int id) async {
    final db = await _db.database;
    final maps = await db.query('orders', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Order.fromMap(maps.first);
  }

  Future<int> insert(Order order) async {
    final db = await _db.database;
    return db.insert('orders', order.toMap());
  }

  Future<void> clearAll() async {
    final db = await _db.database;
    await db.delete('orders');
  }
}

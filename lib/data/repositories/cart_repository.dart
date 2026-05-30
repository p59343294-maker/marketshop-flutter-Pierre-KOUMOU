// lib/data/repositories/cart_repository.dart

import '../database_helper.dart';
import '../models/cart_item.dart';

class CartRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<CartItem>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('cart_items');
    return maps.map(CartItem.fromMap).toList();
  }

  Future<CartItem?> getByProductId(int productId) async {
    final db = await _db.database;
    final maps = await db.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    if (maps.isEmpty) return null;
    return CartItem.fromMap(maps.first);
  }

  Future<void> addOrUpdate(CartItem item) async {
    final db = await _db.database;
    final existing = await getByProductId(item.productId);
    if (existing != null) {
      await db.update(
        'cart_items',
        {'quantity': existing.quantity + item.quantity},
        where: 'id = ?',
        whereArgs: [existing.id],
      );
    } else {
      await db.insert('cart_items', item.toMap());
    }
  }

  Future<void> updateQuantity(int id, int quantity) async {
    final db = await _db.database;
    await db.update(
      'cart_items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _db.database;
    await db.delete('cart_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAll() async {
    final db = await _db.database;
    await db.delete('cart_items');
  }
}

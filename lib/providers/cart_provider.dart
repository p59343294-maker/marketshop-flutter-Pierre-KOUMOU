// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../data/models/cart_item.dart';
import '../data/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repo = CartRepository();
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  double get total => _items.fold(0, (sum, i) => sum + i.subtotal);
  bool get isEmpty => _items.isEmpty;

  Future<void> load() async {
    _items = await _repo.getAll();
    notifyListeners();
  }

  Future<void> addItem(CartItem item) async {
    await _repo.addOrUpdate(item);
    await load();
  }

  Future<void> updateQuantity(int id, int quantity) async {
    if (quantity <= 0) {
      await _repo.delete(id);
    } else {
      await _repo.updateQuantity(id, quantity);
    }
    await load();
  }

  Future<void> removeItem(int id) async {
    await _repo.delete(id);
    await load();
  }

  Future<void> clear() async {
    await _repo.clearAll();
    _items = [];
    notifyListeners();
  }
}

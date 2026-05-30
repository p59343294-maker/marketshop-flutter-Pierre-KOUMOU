// lib/providers/order_provider.dart

import 'package:flutter/material.dart';
import '../data/models/order.dart';
import '../data/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repo = OrderRepository();
  List<Order> _orders = [];

  List<Order> get orders => _orders;
  bool get isEmpty => _orders.isEmpty;

  Future<void> load() async {
    _orders = await _repo.getAll();
    notifyListeners();
  }

  Future<void> placeOrder(Order order) async {
    await _repo.insert(order);
    await load();
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    _orders = [];
    notifyListeners();
  }
}

// lib/providers/catalogue_provider.dart

import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../data/models/product.dart';

enum CatalogueStatus { idle, loading, success, error }

class CatalogueProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> _allProducts = [];
  List<Product> _filtered = [];
  List<String> _categories = [];
  String? _selectedCategory;
  CatalogueStatus _status = CatalogueStatus.idle;
  String _errorMessage = '';

  List<Product> get products => _filtered;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  CatalogueStatus get status => _status;
  String get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _status = CatalogueStatus.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _api.getProducts(),
        _api.getCategories(),
      ]);
      _allProducts = results[0] as List<Product>;
      _categories = results[1] as List<String>;
      _filtered = _allProducts;
      _status = CatalogueStatus.success;
    } catch (e) {
      _status = CatalogueStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> filterByCategory(String? category) async {
    _selectedCategory = category;
    if (category == null) {
      _filtered = _allProducts;
      notifyListeners();
      return;
    }
    _status = CatalogueStatus.loading;
    notifyListeners();
    try {
      _filtered = await _api.getProductsByCategory(category);
      _status = CatalogueStatus.success;
    } catch (e) {
      _status = CatalogueStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }
}

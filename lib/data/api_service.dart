// lib/data/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getProducts() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Impossible de charger les produits (${response.statusCode})');
  }

  Future<Product> getProduct(int id) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products/$id'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Produit introuvable');
  }

  Future<List<String>> getCategories() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products/categories'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    }
    throw Exception('Impossible de charger les catégories');
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products/category/$category'))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Impossible de charger les produits de la catégorie');
  }
}

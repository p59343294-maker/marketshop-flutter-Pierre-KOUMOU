// lib/data/models/order.dart

import 'dart:convert';

class OrderItem {
  final int productId;
  final String title;
  final double price;
  final String image;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'price': price,
        'image': image,
        'quantity': quantity,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json['productId'] as int,
        title: json['title'] as String,
        price: (json['price'] as num).toDouble(),
        image: json['image'] as String,
        quantity: json['quantity'] as int,
      );
}

class Order {
  final int? id;
  final String orderNumber;
  final DateTime date;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final List<OrderItem> items;
  final double total;

  Order({
    this.id,
    required this.orderNumber,
    required this.date,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.items,
    required this.total,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'orderNumber': orderNumber,
        'date': date.toIso8601String(),
        'fullName': fullName,
        'phone': phone,
        'address': address,
        'city': city,
        'items': jsonEncode(items.map((e) => e.toJson()).toList()),
        'total': total,
      };

  factory Order.fromMap(Map<String, dynamic> map) => Order(
        id: map['id'] as int?,
        orderNumber: map['orderNumber'] as String,
        date: DateTime.parse(map['date'] as String),
        fullName: map['fullName'] as String,
        phone: map['phone'] as String,
        address: map['address'] as String,
        city: map['city'] as String,
        items: (jsonDecode(map['items'] as String) as List)
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: (map['total'] as num).toDouble(),
      );
}

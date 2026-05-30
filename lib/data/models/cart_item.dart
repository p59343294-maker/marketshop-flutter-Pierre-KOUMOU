// lib/data/models/cart_item.dart

class CartItem {
  final int? id; // id en base
  final int productId;
  final String title;
  final double price;
  final String image;
  int quantity;

  CartItem({
    this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'productId': productId,
        'title': title,
        'price': price,
        'image': image,
        'quantity': quantity,
      };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
        id: map['id'] as int?,
        productId: map['productId'] as int,
        title: map['title'] as String,
        price: (map['price'] as num).toDouble(),
        image: map['image'] as String,
        quantity: map['quantity'] as int,
      );

  CartItem copyWith({int? quantity}) => CartItem(
        id: id,
        productId: productId,
        title: title,
        price: price,
        image: image,
        quantity: quantity ?? this.quantity,
      );
}

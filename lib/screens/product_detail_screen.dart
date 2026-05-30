// lib/screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../data/api_service.dart';
import '../data/models/product.dart';
import '../data/models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _api = ApiService();
  Product? _product;
  bool _loading = true;
  String? _error;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final product = await _api.getProduct(widget.productId);
      setState(() {
        _product = product;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  Future<void> _addToCart() async {
    if (_product == null) return;
    final cartItem = CartItem(
      productId: _product!.id,
      title: _product!.title,
      price: _product!.price,
      image: _product!.image,
      quantity: _quantity,
    );
    await context.read<CartProvider>().addItem(cartItem);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Ajouté au panier !'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail produit')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _loadProduct, child: const Text('Réessayer')),
                    ],
                  ),
                )
              : _buildBody(),
      bottomNavigationBar: _product != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildBody() {
    final product = _product!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grande image
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: CachedNetworkImage(
              imageUrl: product.image,
              fit: BoxFit.contain,
              placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Catégorie + note
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating.rate} (${product.rating.count} avis)',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Titre
                Text(
                  product.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, height: 1.3),
                ),
                const SizedBox(height: 12),
                // Prix
                Text(
                  '${product.price.toStringAsFixed(2)} €',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 16),
                // Description
                const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                // Sélecteur quantité
                const Text('Quantité', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQtyBtn(Icons.remove, () {
                      if (_quantity > 1) setState(() => _quantity--);
                    }),
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ),
                    _buildQtyBtn(Icons.add, () => setState(() => _quantity++)),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _addToCart,
          icon: const Icon(Icons.shopping_cart_outlined),
          label: Text(
            'Ajouter au panier — ${(_product!.price * _quantity).toStringAsFixed(2)} €',
          ),
        ),
      ),
    );
  }
}
